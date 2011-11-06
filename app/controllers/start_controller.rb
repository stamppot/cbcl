class StartController < ApplicationController
  # helper SurveyHelper

  def start
    @page_title = "CBCL Spørgeskemaer" 
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    logger.info "LOGIN_USER cookie: #{cookies[:journal_entry]} #{@journal_entry.id} #{@journal_entry.login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    redirect_to login_path and return if @journal_entry.nil?
    @survey = @journal_entry.survey
    redirect_to survey_finish_path(@journal_entry) and return if @journal_entry.answered?
  end

  def edit
    @page_title = "CBCL Spørgeskemaer" 
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil?
    @survey = @journal_entry.survey
  end

  def finish
    @journal_entry = JournalEntry.find(params[:id])
    # @survey_type = @journal_entry.survey.surveytype
    cookies.delete "journal_entry"
  end

  def check_logged_in
    true
  end

  def check_access
    true
  end
end