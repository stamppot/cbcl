class SurveyAnswersController < ApplicationController
  layout 'cbcl', :except => [ :show, :show_fast ]
  layout 'survey', :only  => [ :show, :show_fast, :edit ]


  def show #_answer
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = Rails.cache.fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    # render :text => @survey.to_s.inspect
    render :template => 'surveys/show' #, :layout => "layouts/showsurvey"
  end
  
  def show_fast # show_answer_fast
    @options = {:action => "show", :answers => true}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = @journal_entry.survey_answer
    @survey = Rails.cache.fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    render :template => 'surveys/show_fast' #, :layout => "layouts/showsurvey"
  end

  def edit  # was: change_answer
    @options = {:answers => true, :show_all => true, :action => "edit"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = @journal_entry.survey_answer
    @survey = Rails.cache.fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Ret Svar: " << @survey.title
    render :template => 'surveys/show'
  end

  # updates survey page with dynamic data. Consider moving to separate JavascriptsController
  def dynamic_data
    @journal_entry = JournalEntry.find(params[:id], :include => {:journal => :person_info})
    save_interval = current_user && current_user.login_user && 30 || 20 # change to 900, 60
    save_draft_url = "/survey_answers/save_draft/#{@journal_entry.id}"
    
    respond_to do |format|
      if current_user.nil?
        format.js {
          render :update do |page|
            page.replace_html 'centertitle', "Du er ikke logget ind"
            page.visual_effect :pulsate, 'centertitle'
            page.visual_effect :blind_up, 'content_survey', :duration => 6
            page.visual_effect :fade, 'surveyform', :duration => 6
            page.alert "Du bliver sendt til login-siden."
            page.redirect_to login_path
          end
        }
      elsif current_user && !current_user.login_user
        format.js {
          render :update do |page|
            page.replace_html 'centertitle', @journal_entry.journal.center.title
            page.insert_html :bottom, 'survey_journal_info', :partial => 'surveys/survey_header_info'
            page.insert_html :bottom, 'survey_fast_input', :partial => 'surveys/fast_input_button'
            page.insert_html :bottom, 'back_button', :partial => 'surveys/back_button'
            page.show 'submit_button'
          end
        }
      else # login users
        format.js {
          render :update do |page|
            page.replace_html 'centertitle', @journal_entry.journal.center.title
            page.insert_html :bottom, 'survey_journal_info', :partial => 'surveys/survey_header_info_login_user'
            page.show 'submit_button'
          end
        }
      end
    end
  end
  
  def save_draft
    journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    survey = Rails.cache.fetch("survey_entry_#{journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(journal_entry.survey_id)
    end
    if journal_entry.survey_answer.nil?
      journal = journal_entry.journal
      journal_entry.survey_answer = SurveyAnswer.create(:survey => survey, :age => journal.age, :sex => journal.sex_text, 
            :surveytype => survey.surveytype, :nationality => journal.nationality, :journal_entry => journal_entry)
    end
    survey_answer = journal_entry.survey_answer
    survey_answer.save_answers(params)
    journal_entry.answered_at = Time.now
    journal_entry.draft!
    survey_answer.save
  end
  
  def create
    if current_user.login_user && (journal_entry = cookies[:journal_entry])
      params[:id] = journal_entry # login user can access survey with survey_id instead of journal_entry_id
    end
    id = params.delete("id")
    @journal_entry = JournalEntry.find(id)

    @center = @journal_entry.journal.center
    @subscription = @center.subscriptions.detect { |sub| sub.survey_id == @journal_entry.survey_id }

    if @subscription.nil? || @subscription.inactive?
      flash[:error] = @subscription && t('subscription.expired') || ('subscription.none_for_this_survey')
      redirect_to @journal_entry.journal and return
    end

    survey = Rails.cache.fetch("survey_entry_#{@journal_entry.id}", :expires_in => 20.minutes) do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    survey_answer = @journal_entry.make_survey_answer
    
    if survey_answer.save_all(params)
      @journal_entry.increment_subscription_count(survey_answer)

      # login-users are shown the logout page
      if current_user and current_user.access? :all_users
        flash[:notice] = "Dit svar er gemt."
        redirect_to journal_path(@journal_entry.journal) and return
      else
        flash[:notice] = "Tak for dit svar!"
        cookies.delete :journal_entry
        redirect_to survey_finish_path(@journal_entry.login_user) and return
      end
    else
      flash[:notice] = "Fejl! Dit svar blev ikke gemt."
      redirect_to survey_answer_path(@journal_entry) and return
    end
  rescue RuntimeError
    flash[:error] = survey_answer.print
    redirect_to journal_path(@journal_entry.journal) and return
  end
  
  def update
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    survey_answer = @journal_entry.survey_answer
    survey = survey_answer.survey
    survey_answer.save_answers(params)
    # survey.merge_answertype(survey_answer) # 19-7 obsoleted! answertype is saved when saving draft
    if survey_answer.save
      Task.new.create_csv_answer(survey_answer)
      redirect_to journal_path(@journal_entry.journal)
    else  # not answered
      flash[:notice] = "Dit svar blev ikke gemt."
    end
  end  
  

  protected
  
  before_filter :check_access# , :except => [:dynamic_data]
  
  def check_access
    redirect_to login_path and return unless current_user
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      id = params[:id].to_i
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include?(id)
      else  # show methods uses journal_entry id
        current_user.journal_entry_ids.include?(id)
      end
    else
      redirect_to login_path
    end
  end
end
