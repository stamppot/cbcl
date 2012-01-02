class ExportsController < ApplicationController
  
  def index
    @center = current_user.center unless current_user.access? :admin
    @center = Center.find(params[:id]) if params[:id]
    
    args = params
    # set default dates
    params[:start_date] ||= (SurveyAnswer.first && SurveyAnswer.first.created_at)
    params[:stop_date] ||= (SurveyAnswer.last && SurveyAnswer.last.created_at)

    params = filter_date(args)
    @start_date, @stop_date = params[:start_date], params[:stop_date]

    # filter age
    @start_age = params[:age_start] = 1
    @stop_age = params[:age_stop]  = 21
    params = Query.filter_age(args)

    @surveys = current_user.subscribed_surveys
    # set default value to true unless filter is pressed
    @surveys = surveys_default_selected(@surveys, params[:surveys])
    filter_surveys = @surveys.collect_if(:selected) { |s| s.id }
    @center = current_user.center if current_user.centers.size == 1
    params[:center] = @center if @center
    
    # clean params
    params.delete(:action); params.delete(:controller); params.delete(:limit); params.delete(:offset)
    
    @count_survey_answers = current_user.count_survey_answers(params.merge({:surveys => filter_surveys}))
  end
  
  def filter
    center = Center.find params[:center] unless params[:center].blank?
    params[:surveys][:id] = params[:surveys][params[:surveys][:id]] = 1
    params[:surveys].delete :id
    puts "params: #{params.inspect}"
    args = params
    params = filter_date(args)
    surveys = current_user.subscribed_surveys
    params = Query.filter_age(params)
    
    # set default value to true unless filter is pressed
    params[:surveys] ||= []
    surveys = Survey.selected(params[:surveys].blank? && [] || params[:surveys].keys)
    center = current_user.center if current_user.centers.size == 1
    params[:center] = center if center

    journals = center && center.journals.flatten.size || Journal.count
    count_survey_answers = current_user.count_survey_answers(filter_date(params).merge({:surveys => surveys}))
    count_survey_answers = SurveyAnswer.finished.count if count_survey_answers == 0
    
    render :update do |page|
      page.replace_html 'results', "Journaler: #{journals}  Skemaer: #{count_survey_answers.to_s}"
      page.visual_effect :shake, 'results'
      page.replace_html 'centertitle', center.title if center
    end
  end

  def download
    params[:surveys][:id] = params[:surveys][params[:surveys][:id]] = 1
    params[:surveys].delete :id
    args = params
    params = filter_date(args)
    params = Query.filter_age(params)

    @surveys = current_user.subscribed_surveys
    # set default value to true unless filter is pressed
    params[:surveys] ||= []
    @surveys = Survey.selected(params[:surveys].blank? && [] || params[:surveys].keys)
    @center = current_user.center if current_user.centers.size == 1
    
    @center = Center.find params[:center] unless params[:center].blank?
    params[:center] = @center if @center

    survey_answers = current_user.survey_answers(filter_date(params).merge({:surveys => @surveys})).compact
    
    # spawns background task
    @task = Task.create(:status => "In progress")
    @task.create_export(@surveys.map(&:id), survey_answers)
  end
  
  # a periodic updater checks the progress of the export data generation 
  def generating_export
    @task = Task.find(params[:id])
    
    respond_to do |format|
      format.js {
        puts "GENERATING JS"
        render :update do |page|
          if @task.completed?
            page.visual_effect :blind_up, 'content'
            page.redirect_to export_file_path(@task.export_file) # and return  #, :content_type => 'application/javascript'
          else
            page.insert_html :after, 'progress', '.'
            page.visual_effect :pulsate, 'progress'
            page.visual_effect :highlight, 'progress'
          end
        end
      }
      format.html do
        puts "GENERATING HTML"
        redirect_to export_file_path(@task.export_file) and return if @task.completed?
      end
    end
  end
  
  def show_range
    @start_date = Date.civil(params[:range][:"start_date(1i)"].to_i,params[:range][:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
  end
  
  def set_age_range
    @start_age = params[:age][:start].to_i
    @stop_age  = params[:age][:stop].to_i

    render :update do |page|
      if @start_age > @stop_age
        params[:id] == "up" ? @stop_age = @start_age : @start_age = @stop_age

        page.replace_html 'select_age', :partial => 'select_age', :locals => {:start_age => @start_age, :stop_age => @stop_age}
        page.visual_effect :highlight, 'stop_age'
        page.visual_effect :highlight, 'start_age'
      end
      # page.hide 'filter_form'
    end
  end

  
  protected

  
  before_filter :header_javascript, :only => [:generating_export]
  
  def header_javascript
    response.headers['Content-type'] = 'text/javascript; charset=utf-8'
  end

  def filter_date(args)
    if args[:start_date] && args[:stop_date]
      start = args.delete(:start_date)
      stop  = args.delete(:stop_date)
    end
    Query.set_time_args(start, stop, args) # TODO: move to better place/helper?! also used in Query
  end
  
  def surveys_default_selected(surveys, params)
    if selected = params
      surveys.each { |s| s.selected = (selected["#{s.id}"] == "1") }
    else
      surveys.each { |s| s.selected = true }
    end
    return surveys
  end
  
  def check_access
    if !current_user || current_user.login_user
      redirect_to login_path
    end
  end
end