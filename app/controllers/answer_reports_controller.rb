class AnswerReportsController < ApplicationController
  
  layout 'no_menu'
  
  def show
    redirect_to journals(params[:journal_id]) and return if params[:answers].nil?
    
    score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
    @journal = score_report.journal
    @titles  = score_report.titles #.map {|t| t.gsub("nn", "<br/>")}
    @groups  = score_report.groups
    @scales  = score_report.scales
    @group_titles = score_report.group_titles

    @answer_texts = []
    params[:answers].keys.each do |journal_id|
      journal_entry = JournalEntry.and_survey_answer.find(journal_id)
      survey_answer = SurveyAnswer.and_answer_cells.find(journal_entry.survey_answer_id)
      survey = Survey.and_questions.find(survey_answer.survey_id)
      questions = survey.merge_report_answer(survey_answer)
      @answer_texts << {:questions => questions, :survey => survey}
    end
    
    @page_title = "CBCL - Udvidet Svarrapport: " << @journal.title
  end 
end
