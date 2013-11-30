class SurveyAnswersController < ApplicationController
  layout 'cbcl', :except => [ :show, :show_fast ]
  layout 'survey', :only  => [ :show, :show_fast, :edit, :print ]
  # layout 'survey_print', :only => [ :print ]

  @@surveys = {}

  # should answered survey (merged with answers), which can be saved (send button)
  def show # BROKEN layout
    cookies.delete :journal_entry
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    cookies[:journal_entry] = @journal_entry.id
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @@surveys[@journal_entry.survey_id] ||= Survey.and_questions.find(@survey_answer.survey_id)
    @survey = @@surveys[@journal_entry.survey_id]
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svar: " << @survey.get_title
    render :layout => 'survey' # :template => 'surveys/show'
  end

  # def show_fast
  #   @options = {:action => "show", :answers => true}
  #   @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
  #   @survey_answer = @journal_entry.survey_answer
  #   @@surveys[@journal_entry.survey_id] ||= Survey.and_questions.find(@survey_answer.survey_id)
  #   @survey = @@surveys[@journal_entry.survey_id]
  #   @survey.merge_survey_answer(@survey_answer)
  #   @page_title = "CBCL - Vis Svar: " << @survey.get_title
  #   render :template => 'surveys/show_fast' #, :layout => "layouts/showsurvey"
  # end

  def edit
    journal_entry = JournalEntry.find(params[:id])
    session[:journal_entry] = params[:id]
    redirect_to survey_path(journal_entry.survey_id)
  end

  def print # this is dangerous because it changes @survey
    @options = {:answers => true, :disabled => false, :action => "print"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = Survey.and_questions.find(@survey_answer.survey_id)
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Udskriv Svar: " << @survey.get_title
  end

  # updates survey page with dynamic data. Consider moving to separate JavascriptsController
  def dynamic_data
    @journal_entry = JournalEntry.find(params[:id], :include => :journal)
    save_interval = current_user && current_user.login_user && 30 || 20 # change to 900, 60
    save_draft_url = "/survey_answers/save_draft/#{@journal_entry.id}"

    logger.info "dynamic_data: current_user: #{current_user.inspect} entry: #{@journal_entry.inspect}"
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
            page.replace_html 'centertitle', @journal_entry.journal.center.get_title
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
            page.replace_html 'centertitle', @journal_entry.journal.center.get_title
            page.insert_html :bottom, 'survey_journal_info', :partial => 'surveys/survey_header_info_login_user'
            page.show 'save_draft'
            page.show 'submit_button'
          end
        }
      end
    end
  rescue RecordNotFound
    render :update do |page|
      logger.info "dynamic_data: fejl! #{@journal_entry.id} journal id/kode: #{@journal_entry.journal.id}/#{@journal_entry.journal.code}"
      page.alert "Der er sket en fejl, du skal logge ud og ind igen", @journal_entry.journal.center.get_title
      page.redirect_to logout_path
    end
  end
  
  def draft_data
		@response = journal_entry = JournalEntry.find(params[:id], :include => {:survey_answer => {:answers => :answer_cells}})
		show_fast = params[:fast] || false

    cell_count = 0
		@response = if journal_entry.survey_answer
			all_answer_cells = journal_entry.survey_answer.setup_draft_values
      cell_count = all_answer_cells.size
			all_answer_cells.inject([]) {|col,ac| col << ac.javascript_set_value(show_fast); col }.flatten.compact.join
		end || ""
    # logger.info "JAVASCRIPT DRAFT RESPONSE: #{@response}"
    j = journal_entry.journal
    je = journal_entry
    logger.info "draft: current_user: #{current_user.inspect} entry: #{@journal_entry.inspect}"
    logger.info "draft_data: cookie: #{cookies[:journal_entry]} session[:journal_entry]: #{session[:journal_entry]} entry: #{je.id} journal: #{j.id} answer_cells: #{cell_count}"
		respond_to do |format|
			format.js {
        # render :update do |page|
        #   page << @response.to_s
        # end
			}
		end
	end
  
  def json_dynamic_data
    @journal_entry = JournalEntry.find(params[:id], :include => :journal)
    save_interval = current_user && current_user.login_user && 30 || 20 # change to 900, 60
    save_draft_url = "/survey_answers/save_draft/#{@journal_entry.id}"
    @journal = @journal_entry.journal
    
    # logger.info "dynamic json: current_user: #{current_user.inspect} center: #{@journal.center.get_title} entry: #{@journal_entry.inspect}  journal: #{@journal.inspect}"
    json = {}
    json[:logged_in] = !current_user.nil?
    json[:login_user] = current_user && current_user.login_user
    json[:center_title] = current_user && @journal.center.get_title || "Du er ikke logget ind"
    json[:show_save_draft] = !current_user.nil?
    json[:show_submit] = !current_user.nil?
    json[:save_draft_url] = save_draft_url
    json[:journal_entry_id] = params[:id]

    if current_user && !current_user.login_user
      json[:journal_info] = @journal.name
      json[:journal_code] = @journal.qualified_id
      json[:name] = @journal.name
      json[:birthdate] = @journal.birth_short 
    elsif current_user && current_user.login_user # login users
      json[:journal_info] = @journal.name
    end

    respond_to do |format|
      format.json { render :text => json.to_json}
    end
  rescue RecordNotFound
    render :update do |page|
      logger.info "dynamic_data: fejl! #{@journal_entry.id} journal id/kode: #{@journal.id}/#{@journal.code}"
      page.alert "Der er sket en fejl, du skal logge ud og ind igen", @journal.center.get_title
      page.redirect_to logout_path
    end
  end

  def json_draft_data
    journal_entry = JournalEntry.find(params[:id], :include => {:survey_answer => {:answers => :answer_cells}})
    show_fast = params[:fast] || false

    cell_count = 0
    # @response = 
    all_answer_cells = if journal_entry.survey_answer
      journal_entry.survey_answer.setup_draft_values
    end || []
    cell_count = all_answer_cells.size
      
    draft_cells = all_answer_cells.map {|ac| ac.json_draft_value }   # DraftCell.new(ac) }
    # logger.info "JAVASCRIPT DRAFT RESPONSE: #{@response}"
    # logger.info "JAVASCRIPT DRAFT CELLS: #{draft_cells.to_json}"
    
    j = journal_entry.journal
    je = journal_entry
    logger.info "draft_data: cookie: #{cookies[:journal_entry]} session[:journal_entry]: #{session[:journal_entry]} entry: #{je.id} journal: #{j.id} answer_cells: #{cell_count}"
    respond_to do |format|
      format.html { puts "json_draft_data html"; render :text => "hello world" }
      format.js { puts "json_draft_data js"; render }
      format.json { puts "json_draft_data json"; render :text => draft_cells.to_json }
        # render :update do |page|
        #   page << @response.to_s
        # end
    end
  end

  def save_draft
    return if request.get?
    journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    journal_entry.draft! # unless journal_entry.answered?
    return if journal_entry.answered?

    request.session_options[:id] # touch (lazy) session
    current_user.id

    if journal_entry.survey_answer.nil? || !journal_entry.answered?
      journal_entry.make_survey_answer
      journal_entry.survey_answer.save
    end
    j = journal_entry.journal
    je = journal_entry
    logger.info "save_draft journal: #{j.id} kode: #{j.code} entry cookie: '#{session[:journal_entry]}' entry: '#{je.id}' survey: #{je.survey_id} luser: '#{je.user_id}' #{request.env['HTTP_USER_AGENT']}"

    spawn do
      journal_entry.survey_answer.save_draft(params)
    end
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
      if !journal_entry.valid?
        puts "journal_entry.errors: #{journal_entry.errors.inspect}  \n login_user.groups: #{journal_entry.login_user.groups.maps {|g| g.errors}.flatten.inspect}"
      end
		end
		
    if !survey_answer.save_final(params)
      flash[:notice] = "Fejl! Dit svar blev ikke gemt."
      redirect_to survey_answer_path(journal_entry) and return
    end
    
    journal_entry.increment_subscription_count(survey_answer)

		# puts "SURVEYANSWERCONT current_user: #{current_user.inspect} LOGIN_USER: #{current_user.login_user?}"
    # login-users are shown the finish page
    if current_user and current_user.access? :all_users
      flash[:notice] = "Besvarelsen er gemt."
      redirect_to journal_path(journal_entry.journal) and return
    else
      flash[:notice] = "Tak for dit svar!"
			# puts "GOING TO FINISH PAGE: #{journal_entry.inspect}\n   current_user: #{current_user.inspect}"
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

    if survey_answer.save
      survey_answer.generate_score_report(update = true)
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

  def edit_date
    @journal_entry = JournalEntry.find(params[:id])
    # @date = @journal_entry.created
    # @follow_up = @journal_entry.get_follow_up
    @follow_ups = JournalEntry.follow_ups
    puts "follow_up: #{@follow_up}"
    puts "follow_ups: #{@follow_ups.inspect}"
    render :layout => 'cbcl'
  end

  # update survey_answer, journal_entry.answered_at, csv_survey_answers.age, csv_score_rapports.age | created_at, csv_answers.age
  def update_date
    entry = JournalEntry.find(params[:journal_entry][:id])
    entry.follow_up = params[:journal_entry][:follow_up]
    date_param = params[:journal_entry][:created]

    if date_param.blank?
      entry.save
      flash[:notice] = "Opfølgning er rettet"
      redirect_to journaL_path(entry.journal)
    end

    sep = date_param.include?("/") && "/" || date_param.include?("-") && "-"
    d = date_param.split(sep).map {|p| p.to_i }
    date = [d[2],d[1],d[0]]
    created = Date.new(*date)
    entry.update_date(created)
    # age = ((created - entry.journal.birthdate).to_i / 365.25).floor
    # entry.survey_answer.age = age
    # entry.answered_at = created
    # entry.save
    
    # entry.survey_answer.created_at = created
    # entry.survey_answer.save
    
    # csv_score_rapport = CsvScoreRapport.find_by_survey_answer_id(entry.survey_answer_id)
    # if csv_score_rapport
    #   csv_score_rapport.age = age if csv_score_rapport
    #   csv_score_rapport.created_at = created
    #   csv_score_rapport.save
    # end
    # csv_survey_answer = CsvSurveyAnswer.find_by_journal_entry_id(entry.id)
    # if csv_survey_answer
    #   csv_survey_answer.created_at = created
    #   csv_survey_answer.age = age if csv_survey_answer
    #   csv_survey_answer.save
    # end
    # score_rapport = ScoreRapport.find_by_survey_answer_id(entry.survey_answer_id)
    # if score_rapport
    #   score_rapport.age = age
    #   score_rapport.created_at = created
    #   score_rapport.save
    # end
    
    flash[:notice] = "Besvarelsesdato og opfølgning er rettet"
    redirect_to journal_path(entry.journal)
  end

  def log_error
    logger.info "save_draft log_error params #{params.inspect}"
  end

  protected
  
  before_filter :check_access, :except => [:save_draft, :dynamic_data]
  
  def check_access
    redirect_to login_path and return unless current_user
		return true if current_user.admin?
    if current_user.access?(:all_users) || current_user.access?(:login_user)
      id = params[:id].to_i
      access = if params[:action] =~ /show_only/
        current_user.surveys.map {|s| s.id }.include?(id)
      else  # show methods uses journal_entry id
        current_user.has_journal_entry?(id)
      end
    else
      redirect_to login_path
    end
  end
end
