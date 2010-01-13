class StartController < ApplicationController
  # helper SurveyHelper
  
  def start
    @page_title = "CBCL Spørgeskemaer" 
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    redirect_to login_path and return if @journal_entry.nil?
    @text = @journal_entry.survey_answer && "Ændre svar" || "Start"
    @survey = @journal_entry.survey
  end
  
  def finish
    login_user = LoginUser.find_by_id(params[:id])
    # login_user.destroy if login_user
    remove_current_user
  end
  
end