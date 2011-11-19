class StartController < ApplicationController

  def start
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    session[:journal_entry] ||= @journal_entry.id
    # debugger
    logger.info "LOGIN_USER start cookie: '#{session[:journal_entry]}' '#{@journal_entry.id}' '#{@journal_entry.login_user.id}' @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 2.hour.from_now }
    redirect_to survey_continue_path if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry) and return if @journal_entry.answered?
    @survey = @journal_entry.survey
  end

  def continue
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    cookies[:journal_entry] = @journal_entry.id # session[:journal_entry]
    logger.info "LOGIN_USER continue cookie: #{session[:journal_entry]} #{@journal_entry.id} #{@journal_entry.login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    @survey = @journal_entry.survey
  end

  def finish
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to survey_continue_path and return unless @journal_entry.answered?
    @survey = @journal_entry.survey
    session.delete "journal_entry"
  end

  def check_logged_in
    session["journal_entry"] != nil && current_user
  end

  def check_access
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil? 
  end
end