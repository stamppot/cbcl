class SurveyAnswersController < ApplicationController
  layout 'cbcl', :except => [ :show, :show_fast ]
  layout 'survey', :only  => [ :show, :show_fast, :edit ]
	layout 'survey_print', :only => [ :print ]

  # caching, do not use
  # def show
  #     self.expires_in 2.months.from_now
  #     @options = {:show_all => true, :action => "create"}
  #     survey_id = params[:id]
  #   params[:id] &&= cookies["journal_entry"] # survey_id is stored in cookie. all users access survey with survey_id for caching
  #   session.delete :user_name if current_user.login_user?  # remove flash welcome message
  #   journal_entry = JournalEntry.find(params[:id])
  #   @survey = cache_fetch("survey_#{survey_id}") do  
  #     Survey.find(survey_id)
  #   end
  #   @page_title = @survey.title
  #   rescue ActiveRecord::RecordNotFound
  # end 

  # should answered survey (merged with answers), which can be saved (send button)
  def show # BROKEN layout
    cookies.delete :journal_entry
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    cookies[:journal_entry] = @journal_entry.id
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = cache_fetch("survey_entry_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    render :layout => 'survey' # :template => 'surveys/show'
  end

  def show_fast
    @options = {:action => "show", :answers => true}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = @journal_entry.survey_answer
    @survey = cache_fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@journal_entry.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.title
    render :template => 'surveys/show_fast' #, :layout => "layouts/showsurvey"
  end

  def edit
    # @options = {:answers => true, :show_all => true, :action => "edit"}
    journal_entry = JournalEntry.find(params[:id])
    session[:journal_entry] = params[:id]
    redirect_to survey_path(journal_entry.survey_id)
    # @survey_answer = @journal_entry.survey_answer
    # @survey = cache_fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
    #   Survey.and_questions.find(@survey_answer.survey_id)
    # end
    # @survey.merge_survey_answer(@survey_answer)
    # @page_title = "CBCL - Ret Svar: " << @survey.title
    # render :layout => 'survey', :template => 'survey_answers/show'
  end

  def print
    @options = {:answers => true, :disabled => false, :action => "print"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = cache_fetch("survey_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Udskriv Svar: " << @survey.title
  end

  # updates survey page with dynamic data. Consider moving to separate JavascriptsController
  def dynamic_data
    @journal_entry = JournalEntry.find(params[:id], :include => {:journal => :person_info})
    save_interval = current_user && current_user.login_user && 30 || 20 # change to 900, 60
    save_draft_url = "/survey_answers/save_draft/#{@journal_entry.id}"

    # sleep(3000)
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
            page.show 'save_draft'
            page.show 'submit_button'
          end
        }
      else # login users
        format.js {
          render :update do |page|
            page.replace_html 'centertitle', @journal_entry.journal.center.title
            page.insert_html :bottom, 'survey_journal_info', :partial => 'surveys/survey_header_info_login_user'
            page.show 'save_draft'
            page.show 'submit_button'
          end
        }
      end
    end
  end
  
  def draft_data
		@response = journal_entry = JournalEntry.find(params[:id], :include => {:survey_answer => {:answers => :answer_cells}})
		show_fast = params[:fast] || false

		@response = if journal_entry.survey_answer
			all_answer_cells = journal_entry.survey_answer.setup_draft_values
			all_answer_cells.inject([]) {|col,ac| col << ac.javascript_set_value(show_fast); col }.flatten.compact.join
		end || ""
    puts "JAVASCRIPT DRAFT RESPONSE: #{@response}"
		respond_to do |format|
			format.js {
        # render :update do |page|
        #   page << @response.to_s
        # end
			}
		end
	end
  
  def save_draft
    journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    return if journal_entry.answered?

    survey = cache_fetch("survey_entry_#{journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(journal_entry.survey_id)
    end
    if journal_entry.survey_answer.nil? || !journal_entry.answered?
      journal_entry.make_survey_answer
      journal_entry.survey_answer.save
    end
    survey_answer = journal_entry.survey_answer
		survey_answer.journal_entry_id ||= journal_entry.id
		survey_answer.set_answered_by(params)
    survey_answer.save_answers(params)
		survey_answer.center_id ||= journal_entry.journal.center_id
    journal_entry.draft! # unless journal_entry.answered?
    survey_answer.done = false
    survey_answer.save
  end
  
  def create
    if current_user.login_user && (journal_entry = session[:journal_entry])
      params[:id] = journal_entry # login user can access survey with survey_id instead of journal_entry_id
    end
    id = params.delete("id")
    journal_entry = JournalEntry.find(id)
    # puts "SURVEY AnSWER create #{journal_entry.inspect}"
    center = journal_entry.journal.center
    subscription = center.subscriptions.detect { |sub| sub.survey_id == journal_entry.survey_id }

    if subscription.nil? || subscription.inactive?
      flash[:error] = subscription && t('subscription.expired') || ('subscription.none_for_this_survey')
      redirect_to journal_entry.journal and return
    end

    survey = cache_fetch("survey_entry_#{journal_entry.id}", :expires_in => 20.minutes) do
      Survey.and_questions.find(journal_entry.survey_id)
    end
    survey_answer = journal_entry.make_survey_answer
		if current_user.login_user?
			journal_entry.answered! 
		else 
			journal_entry.answered_paper!
		end
		
    if !survey_answer.save_final(params)
      flash[:notice] = "Fejl! Dit svar blev ikke gemt."
      redirect_to survey_answer_path(journal_entry) and return
    end
    
    journal_entry.increment_subscription_count(survey_answer)

		puts "SURVEYANSWERCONT current_user: #{current_user.inspect} LOGIN_USER: #{current_user.login_user?}"
    
    # login-users are shown the finish page
    if current_user and current_user.access? :all_users
      flash[:notice] = "Besvarelsen er gemt."
      redirect_to journal_path(journal_entry.journal) and return
    else
      flash[:notice] = "Tak for dit svar!"
			puts "GOING TO FINISH PAGE: #{journal_entry.inspect}\n   current_user: #{current_user.inspect}"
      redirect_to survey_finish_path(journal_entry) and return
    end
  rescue RuntimeError
    flash[:error] = survey_answer.print
    redirect_to journal_path(journal_entry.journal) and return
  end
  
  def update
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    survey_answer = @journal_entry.survey_answer
    survey = survey_answer.survey
    survey_answer.save_answers(params)
    # survey.merge_answertype(survey_answer) # 19-7 obsoleted! answertype is saved when saving draft
    if survey_answer.save
      survey_answer.generate_score_report(update = true)
      # Task.new.create_csv_answer(survey_answer)
      Task.new.create_csv_survey_answer
      redirect_to journal_path(@journal_entry.journal)
    else  # not answered
      flash[:notice] = "Dit svar blev ikke gemt."
    end
  end  
  
  def done
    entry = JournalEntry.find params[:id]
    done = entry.survey_answer && entry.survey_answer.done || false
    
    respond_to do |format|
      format.html { render :text => done.to_s }
      format.js { render :text => "{'success': '#{done}'}" }
    end
  end

  protected
  
  before_filter :check_access# , :except => [:dynamic_data]
  
  def check_access
    redirect_to login_path and return unless current_user
		return true if current_user.admin?
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
