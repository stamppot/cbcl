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
  
  def finish
    login_user = LoginUser.find_by_id(params[:id])
    # login_user.destroy if login_user
    remove_current_user
  end
  
end