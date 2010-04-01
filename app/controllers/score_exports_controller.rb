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
    args = params
    params = filter_date(args)
    # start_date, stop_date = params[:start_date], params[:stop_date]
    surveys = current_user.subscribed_surveys
    params = Query.filter_age(params)
    
    # set default value to true unless filter is pressed
    params[:surveys] ||= []
    surveys = Survey.selected(params[:surveys].blank? && [] || params[:surveys].keys)
    center = current_user.center if current_user.centers.size == 1
    params[:center] = center if center

    journals = center && center.journals.flatten.size || Journal.count
    @count_survey_answers = current_user.count_survey_answers(filter_date(params).merge({:surveys => surveys}))
    @count_survey_answers = SurveyAnswer.finished.count if @count_survey_answers == 0
    
    puts "COUNT SURVEY_ANSWERS: #{@count_survey_answers}"
    
    render :update do |page|
      page.replace_html 'results', "Journaler: #{journals}  Skemaer: #{@count_survey_answers.to_s}"
      page.visual_effect :shake, 'results'
      page.replace_html 'centertitle', center.title if center
    end
  end

  def download
    args = params
    params = filter_date(args)
    params = Query.filter_age(params)

    puts "DOWNLOAD SUMSCORES"

    @surveys = current_user.subscribed_surveys
    # set default value to true unless filter is pressed
    params[:surveys] ||= []
    @surveys = Survey.selected(params[:surveys].blank? && [] || params[:surveys].keys)
    @center = current_user.center if current_user.centers.size == 1
    
    @center = Center.find params[:center] unless params[:center].blank?
    params[:center] = @center if @center

    puts "SURVEYS: #{@surveys.size}"
    survey_answers = current_user.survey_answers(filter_date(params).merge({:surveys => @surveys})).compact
    puts "SURVEY_ANSWERS: #{survey_answers.size}"
    # from survey_answers to score_results
    score_rapports = ScoreRapport.all(:conditions => ['survey_answer_id IN (?)', survey_answers.map {|sa| sa.id}], :include => :score_results)
    score_results = score_rapports.map {|sr| sr.score_results}.flatten

    sumscore_groups = SumScoreGroups.new
    puts "SCORE_RESULTS: #{score_results.size}"
    sumscore_groups.read_values(score_results)
    @sumscores = sumscore_groups.calculate_scores
  end
    
    
    
  protected
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
  

  private

  def check_access
    redirect_to login_path unless current_user
    redirect_to login_path unless current_user.access? :admin # current_user.access? :score_exports
  end
  
end