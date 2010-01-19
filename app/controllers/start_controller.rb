class StartController < ApplicationController
  # helper SurveyHelper
  
  def start
    @page_title = "CBCL Spørgeskemaer" 
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil?
    @survey = @journal_entry.survey
    render :edit if @journal_entry.survey_answer
  end
  
  def edit
    @page_title = "CBCL Spørgeskemaer" 
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil?
    @survey = @journal_entry.survey
  end
  
  # def finish
  #   login_user = LoginUser.find_by_id(params[:id])
  #   # login_user.destroy if login_user
  #   remove_current_user
  # end

  def finish
    if session[:rbac_user_id] && (journal_entry = cookies[:journal_entry])  # TODO: put in helper method
      params[:id] = journal_entry # login user can access survey with survey_id instead of journal_entry_id
      entry = JournalEntry.find(params[:id])
      entry.login_user.destroy if current_user.login_user
    end
    self.remove_user_from_session!
    cookies.delete :journal_entry
    cookies.delete :user_name
    redirect_to login_path and return
    flash[:notice] = 'Du vil nu blive logget ud.'
  end
  
end