class StartController < ApplicationController
  helper SurveyHelper
  layout "showsurvey"
  
  def start
    @page_title = "CBCL Spørgeskemaer" 
    @surveys = current_user.surveys
    @journal_entry = JournalEntry.find_by_user_id(current_user.id)
    puts "JOURNAL_ENTRY: #{@journal_entry.inspect}"
    @survey = @journal_entry.survey
    render :template => 'surveys/start'
  end
  
  def finish
    login_user = LoginUser.find_by_id(params[:id])
    login_user.destroy if login_user
    
    flash[:notice] = 'Du vil nu blive logget ud.'
    render :template => 'surveys/finish'
  end
  
  
end