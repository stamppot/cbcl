class ScoreReportsController < ApplicationController

  layout 'no_menu'
  
  def show
     @page_title = "CBCL - Scorerapport"

     score_report = ScoreReportPresenter.new.build(params[:answers], params[:journal_id])
     @journal = score_report.journal
     @titles  = score_report.titles
     @groups  = score_report.groups
     @scales  = score_report.scales
     @group_titles = score_report.group_titles

     @answer_texts = []
   end

end
