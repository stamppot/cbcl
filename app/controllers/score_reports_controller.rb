class ScoreReportsController < ApplicationController

  def create
    @page_title = "CBCL - Scorerapport"
    answers = []

    if params[:answers]
      params[:answers].each { |key, val| answers << key if val.to_i == 1 } # use only checked survey answers
      journal_id = params[:journal_id]

      entries = JournalEntry.find(answers, :include => [ :journal, {:survey => {:scores => [:score_items, :score_refs]}} ] )
      # if no entries are chosen, show the first three
      entries = Journal.find(journal_id).answered_entries.reverse.slice(0,3) if entries.empty?
      survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }

      @journal = entries.first.journal # show journal info
      # create survey titles row  # first header is empty, is in corner
      @titles = [""] + survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }
      # find or create score_rapport
      score_rapports = survey_answers.map { |sa| sa.score_rapport ||= sa.generate_score_report }

      @groups = ScoreReport.scores_in_rows(score_rapports)
      @groups << [ScoreReport.row_unanswered(score_rapports)]

      @group_titles = ScoreScale.all.map {|scale| scale.title}
      # @group_titles[0] = ""  # do not show standard title

      respond_to do |format|
        format.html { puts "score_reports/create html" }
        format.pdf { 
          puts "score_reports/create pdf"
          render :template => 'score_reports/show'
        }
      end
    else
      flash[:error] = "Kunne ikke vise scoreberegning. Er du logget ind?"
      redirect_to journals_path
    end
  end

  def show
    puts "score_report show: #{params.inspect}"
    @page_title = "CBCL - Scorerapport"
    answers = []

    unless params[:answers].nil?
      params[:answers].each { |key, val| answers << key if val.to_i == 1 } # use only checked survey answers
      journal_id = params[:journal_id]

      entries = JournalEntry.find(answers, :include => [ :journal, {:survey => {:scores => [:score_items, :score_refs]}} ] )
      # if no entries are chosen, show the first three
      entries = Journal.find(journal_id).answered_entries.reverse.slice(0,3) if entries.empty?
      survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }

      @journal = entries.first.journal # show journal info
      # create survey titles row  # first header is empty, is in corner
      @titles = [""] + survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }
      # find or create score_rapport
      score_rapports = survey_answers.map { |sa| sa.score_rapport ||= sa.generate_score_report }

      @groups = ScoreReport.scores_in_rows(score_rapports)
      # add unanswered row
      @groups << [ScoreReport.row_unanswered(score_rapports)]

      @group_titles = ScoreScale.all.map {|scale| scale.title}
      # @group_titles[0] = ""  # do not show standard title

      respond_to do |format|
        format.html { }
        format.pdf { 
          puts "score_reports/show pdf"
          render :template => 'score_reports/show'
        }
      end
    else
      flash[:error] = "Kunne ikke vise scoreberegning. Er du logget ind?"
      redirect_to journals_path
    end
  end
end
