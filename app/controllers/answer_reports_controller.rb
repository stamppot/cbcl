class AnswerReportsController < ApplicationController
  
  def show
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    cookies[:journal_entry] = @journal_entry.id
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = cache_fetch("survey_entry_#{@journal_entry.id}", :expires_in => 15.minutes) do
      Survey.and_questions.find(@survey_answer.survey_id)
    end
    @survey.merge_survey_answer(@survey_answer)
    @page_title = "CBCL - Vis Svarrapport: " << @survey.title
    render :layout => 'survey' # :template => 'surveys/show'
    
  end 
end
