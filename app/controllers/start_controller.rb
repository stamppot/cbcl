class StartController < ApplicationController

  def start
    user_name = cookies[:user_name]
    cookies.delete :user_name # if current_user.login_user?
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    # logger.info "Start: current_user: #{current_user.inspect} journal_entry: #{@journal_entry.inspect}"
    session[:journal_entry] ||= @journal_entry.id
    j = @journal_entry.journal
    je = @journal_entry
    time = 9.hours.from_now.to_s(:short)
    logger.info "LOGIN_USER start #{user_name} journal: #{j.id} #{j.title} kode: #{j.code} entry cookie: '#{session[:journal_entry]}' entry: '#{je.id}' survey: je.survey_id luser: '#{je.user_id}' @ #{time}: #{request.env['HTTP_USER_AGENT']}"
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 5.hour.from_now }
    redirect_to survey_continue_path if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry) and return if @journal_entry.answered?
    @survey = @journal_entry.survey
  end

  def continue
    # if !current_user.name.include? 'Jens'
    #   flash[:notice] = "System er under vedligeholdelse. Kom tilbage senere."
    #   redirect_to maintenance_path and return
    # end

    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    je = @journal_entry
    @journal = je.journal
    cookies[:journal_entry] = @journal_entry.id # session[:journal_entry]
    user_name = je.login_user.name
    logger.info "LOGIN_USER conti #{user_name} journal: #{@journal.title} entry cookie: '#{session[:journal_entry]}' entry: '#{je.id}' luser: '#{je.user_id}' @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    @survey = @journal_entry.survey
  end

  def finish
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to survey_continue_path and return unless @journal_entry.answered?
    @survey = @journal_entry.survey
    session.delete "journal_entry"
    survey_answer = @journal_entry.survey_answer
    @update_date = survey_answer && (survey_answer.created_at.end_of_day + 2.weeks) || Date.today
    @can_update_answer = @update_date >= Date.today
    Rails.cache.delete("j_#{self.id}")
  end

  def upgrade
    render :layout => "layouts/cbcl"
  end
  
  def check_logged_in
    session["journal_entry"] != nil && current_user
  end

  def check_access
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil? 
  end
end