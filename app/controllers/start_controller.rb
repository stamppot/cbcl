class StartController < ApplicationController

  def start
    logger.info "LOGIN_USER start cookie: #{cookies[:journal_entry]} #{@journal_entry.id} #{@journal_entry.login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    redirect_to continue_path if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry) and return if @journal_entry.answered?
    @survey = @journal_entry.survey
  end

  def continue
    logger.info "LOGIN_USER continue cookie: #{cookies[:journal_entry]} #{@journal_entry.id} #{@journal_entry.login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    @survey = @journal_entry.survey
  end
  
  # def edit
  #   @survey = @journal_entry.survey
  # end

  def finish
    redirect_to survey_continue_path(@journal_entry) and return unless @journal_entry.answered?
    @survey = @journal_entry.survey
    # @survey_type = @journal_entry.survey.surveytype
    cookies.delete "journal_entry"
  end

  def check_logged_in
    cookies["journal_entry"] != nil && current_user
  end

  def check_access
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil? 
  end
end