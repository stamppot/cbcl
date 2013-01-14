class ScoreExportsController < ApplicationController
  # RESTful /score_exports/:center_code

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
    @age_groups = Survey.all.map {|s| s.age}.uniq
    params = Query.filter_age(args)

    @surveys = current_user.subscribed_surveys
    # set default value to true unless filter is pressed
    @surveys = surveys_default_selected(@surveys, params[:surveys])
    filter_surveys = @surveys.collect_if(:selected) { |s| s.id }
    @center = current_user.center if current_user.centers.size == 1
    params[:center] = @center if @center
    
    # clean params
    params.delete(:action); params.delete(:controller); params.delete(:limit); params.delete(:offset)
    params[:user] = current_user.id
    @count_score_rapports = ScoreRapport.count_with_options(params.merge({:surveys => filter_surveys}))
  end

  def download
    center = Center.find params[:center] unless params[:center].blank?
    args = params
    params = filter_date(args)
    params = Query.filter_age(params)
    
    center = current_user.center if current_user.centers.size == 1
    
    params[:team] = params[:team].delete :team if params[:team] && params[:team][:team]
    csv_score_rapports = CsvScoreRapport.with_options(current_user, params).all
    puts "DOWNLOAD csv_score_rapports: #{csv_score_rapports.size}"
    # spawns background task
    @task = Task.create(:status => "In progress")
    @task.create_score_rapports_export(params[:survey][:id], csv_score_rapports)
  end
   
  # a periodic updater checks the progress of the export data generation 
  def generating_export
    @task = Task.find(params[:id])
    
    respond_to do |format|
      format.js {
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
    
    
  protected
  def filter_date(args)
    if args[:start_date] && args[:stop_date]
      start = args.delete(:start_date)
      stop  = args.delete(:stop_date)
    end
    puts "filter_date: start: #{start.inspect}, stop: #{stop.inspect}"
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
  

  private

  def check_access
    redirect_to login_path unless current_user
    redirect_to login_path unless current_user.access?(:score_export)
  end
  
end