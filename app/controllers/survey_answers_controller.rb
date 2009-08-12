 # require 'pp'

class SurveyAnswersController < ApplicationController

  layout "survey", :except => [ :show, :show_fast ]
  layout "showsurvey", :only  => [ :show, :show_fast, :edit ]


  def show #_answer
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    # render :text => @survey.to_s.inspect
    render :template => 'surveys/show' #, :layout => "layouts/showsurvey"
  end
  
  def show_fast # show_answer_fast
    @options = {:action => "show", :answers => true}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = @journal_entry.survey_answer
    @survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    @survey.merge_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    render :template => 'surveys/show_fast' #, :layout => "layouts/showsurvey"
  end

  def edit  # was: change_answer
    @options = {:answers => true, :show_all => true, :action => "edit"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = @journal_entry.survey_answer
    @survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_answer(@survey_answer)
    @page_title = "CBCL - Ret Svar: " << @survey.title
    render :template => 'surveys/show'
  end

  def save_draft
    # render :text => "<i>Draft saved at #{Time.now}</i>" + "\n\n" + params.inspect
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    survey_answer = @journal_entry.survey_answer
    survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    survey_answer.save_partial_answers(params, survey)
    @journal_entry.answered_at = Time.now
    @journal_entry.draft!
    survey_answer.save
  end
  
  def create  # was: answer
    id = params.delete("id")
    @journal_entry = JournalEntry.find(id)

    @center = @journal_entry.journal.center
    @subscription = @center.subscriptions.detect { |sub| sub.survey.id == @journal_entry.survey.id }

    flash[:error] = if @subscription.nil?
      "Centret abbonnerer ikke på dette spørgeskema."
    elsif not @subscription.active?
      "Dit abonnement er udløbet. Kontakt CBCL-SDU."
    end
    redirect_to journal_path(@journal_entry.entry) if flash[:error]

    survey = Rails.cache.fetch("survey_#{@journal_entry.survey_id}") do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    survey_answer = @journal_entry.make_survey_answer

    # if answered by other, save the textfield instead
    # "answer"=>{"person_other"=>"fester", "person"=>"15"}
     if params[:answer][:person].to_i == Role.get(:other).id
      survey_answer.answered_by = params[:answer][:person_other]
    else
      survey_answer.answered_by = params[:answer][:person] unless params[:answer].nil?
    end      
    survey_answer.save   # must be saved, otherwise partial answers cannot be saved becoz of lack of survey_answer.id
    
    # save with save_draft method
    survey_answer.save_partial_answers(params, survey)
    
    # fills in answertype of answer_cells. Do this by matching them with question_cells
    survey.merge_answertype(survey_answer)  # 19-8 items needed to calculate score!
    survey_answer.done = true
    answered = true
    
    if survey_answer.save # and not @journal_entry.nil?
      @journal_entry.increment_subscription_count(survey_answer)
      # login-users are shown the logout page
      if current_user and current_user.has_access? :all_users
        flash[:notice] = "Dit svar er blevet gemt."
        redirect_to journal_path(@journal_entry.journal)
      else
        flash[:notice] = "Tak for dit svar!"
        redirect_to survey_finish_path(@journal_entry.login_user)
      end
    else
      flash[:notice] = "Fejl! Dit svar blev ikke gemt."
      redirect_to survey_answer_path(@journal_entry)
    end
  rescue RuntimeError
    # STDERR.puts survey_answer.print
    flash[:error] = survey_answer.print
    redirect_to journal_path(@journal_entry.journal)
  end
  
  def update  # was: save_changed_answer
    #render :text => "<i>Draft saved at #{Time.now}</i>"
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    survey_answer = @journal_entry.survey_answer
    survey = survey_answer.survey
    survey_answer.save_partial_answers(params, survey)
    # survey.merge_answertype(survey_answer) # 19-7 obsoleted! answertype is saved when saving draft
    if survey_answer.save
      redirect_to journal_path(@journal_entry.journal)
    else  # not answered
      flash[:notice] = "Dit svar blev ikke gemt."
    end
  end  
  

  # made as recipe 63. Automatically save a draft of a form
  # 27-2-9 is this ever used?
  # def new
  #   if request.get?
  #     @survey_answer = session[:survey_answer_draft] || SurveyAnswer.new
  #   else
  #     @survey_answer = SurveyAnswer.create(params[:survey_answer])  # params should be prepared
  #     session[:survey_answer_draft] = nil
  #     redirect_to :controller => :journal, :action => :show, :id => @journal_entry.journal
  #   end
  # end

  protected
  
  before_filter :check_access
  
  def check_access
    if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
      id = params[:id].to_i
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include? id
      else  # show methods uses journal_entry id
        current_user.journal_entry_ids.include?(id)
      end
    end
  end
end
