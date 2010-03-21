class ScoreReportsController < ApplicationController
  
  def create
    @page_title = "CBCL - Scorerapport"
    answers = []

    unless params[:answers].nil?
      params[:answers].each { |key, val| answers << key if val.to_i == 1 } # use only checked survey answers

      entries = JournalEntry.find(answers, :include => [ :journal, {:survey => {:scores => [:score_items, :score_refs]}} ] )
      if entries.empty? # if no entries are chosen, show the first three
        entries = Journal.find(params[:journal_id]).answered_entries.reverse.slice(0,3)
      end
      survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }
      
      @journal = entries.first.journal # show journal info
      # create survey titles row  # first header is empty, is in corner
      @titles = [""] + survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }

      score_rapports = survey_answers.map { |sa| sa.score_rapport } # get pre-generated score_rapports
      unanswered = ["Ubesvarede"]
      score_rapports.each do |score_rapport|  # find no unanswered
        # score = survey_answer.survey.scores.first
        report = ScoreReport.new
        if score_rapport.unanswered > 100  # temporary, recalculate for wrong values
          score_rapport.unanswered = score_rapport.survey_answer.no_unanswered
          score_rapport.save
        end
        report.result = score_rapport.unanswered
        report.percentile = "&nbsp;"
        unanswered << report
      end

      # holds scores in groups of standard, latent, cross-informant
      @groups = []
      # calculate scores for all scales, for all survey answers
      @scales = ScoreScale.find(:all, :order => :position)

      @scales.each do |scale|
        cols = []           # holds columns of results
        score_rapports.each do |score_rapport| # get scores for current scale
          score_results = score_rapport.score_results.select { |s| s.score_scale_id == scale.id }.sort_by { |s| s.position }
          cols << score_results.map { |result| result.to_report } # array of score_reports
        end

        rows = cols.fill_2d.transpose
        # add header and left column of score titles
        score_names = rows.collect do |row|
          title_row = row.detect {|r| r}
          if title_row && title_row.title
            title_row.title
          else
            "tom"
          end
        end # get score.scale from first of each column
        rows.each { |row| row.insert(0, score_names.shift) }  # insert score_item names in first column
        @groups << rows
      end

      @groups << [unanswered] # add unanswered row
      @group_titles = ScoreScale.all.map {|scale| scale.title}
      @group_titles[0] = ""  # do not show standard title

    else
      flash[:error] = "Kunne ikke vise scoreberegning. Er du logget ind?"
      redirect_to journals_path
    end
  end

end
