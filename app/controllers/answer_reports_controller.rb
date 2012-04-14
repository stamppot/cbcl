class AnswerReportsController < ApplicationController
  
  def show
    @options = {:answers => true, :disabled => false, :action => "show"}
    @journal_entry = JournalEntry.and_survey_answer.find(params[:id])
    # cookies[:journal_entry] = @journal_entry.id
    @survey_answer = SurveyAnswer.and_answer_cells.find(@journal_entry.survey_answer_id)
    @survey = Survey.and_questions.find(@survey_answer.survey_id)
    # @questions = @survey.questions.select { |q| q.question_cells.with_property("input").any? }
    @questions = @survey.merge_report_answer(@survey_answer)

    @page_title = "CBCL - Udvidet Svarrapport: " << @survey.title
    render :layout => 'survey'
  end 
end
