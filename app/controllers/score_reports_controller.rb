class ScoreReportsController < ApplicationController
  
  def show
     @page_title = "CBCL - Scorerapport"

     unless params[:answers].nil?
       score_report = ScoreReportPresenter.new.create(params[:answers], params[:journal_id])
       @journal = score_report.journal
       @titles  = score_report.titles
       @groups  = score_report.groups
       @scales  = score_report.scales
       @group_titles = score_report.group_titles

       @answer_texts = []
       # TODO: make it work for multiple answers
       # params[:answers].keys.each do |journal_id|
         # journal_entry = JournalEntry.and_survey_answer.find(journal_id)
         # survey_answer = SurveyAnswer.and_answer_cells.find(journal_entry.survey_answer_id)
         # survey = Survey.and_questions.find(survey_answer.survey_id)
         # questions = survey.merge_report_answer(survey_answer)
         # @answer_texts << {:questions => questions, :survey => survey}
       # end       
     else
       flash[:error] = "Kunne ikke vise scoreberegning. Er du logget ind?"
       redirect_to journals_path
     end
   end

end
