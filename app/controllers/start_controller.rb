class StartController < ApplicationController

  def start
    user_name = cookies[:user_name]
    cookies.delete :user_name if current_user.login_user?
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    session[:journal_entry] ||= @journal_entry.id

    logger.info "LOGIN_USER #{user_name} start cookie: '#{session[:journal_entry]}' entry: '#{@journal_entry.id}' luser: '#{@journal_entry.login_user.id}' @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
    cookies[:journal_entry] = { :value => session[:journal_entry], :expires => 2.hour.from_now }
    redirect_to survey_continue_path if @journal_entry.draft?
    redirect_to survey_finish_path(@journal_entry) and return if @journal_entry.answered?
    @survey = @journal_entry.survey
  end

  def continue
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    cookies[:journal_entry] = @journal_entry.id # session[:journal_entry]
    logger.info "LOGIN_USER continue cookie: #{session[:journal_entry]} entry: #{@journal_entry.id} luser: #{@journal_entry.login_user.id} @ #{9.hours.from_now.to_s(:short)}: #{request.env['HTTP_USER_AGENT']}"
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