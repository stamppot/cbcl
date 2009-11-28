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

      @survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }

      # store score_rapport in model
      @survey_answers.each { |sa| sa.calculate_score }

      # must show journal info
      @journal = entries.first.journal

      # create survey titles row
      # @titles = [""]    # first header is empty, is in corner
      @titles = [""] + @survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }
      # @survey_answers.each do |survey_answer|
      #   @titles << survey_answer.survey.category + " " + survey_answer.survey.age
      # end

      # holds scores in groups of standard, latent, cross-informant
      @groups = []

      @unanswered = ["Ubesvarede"]
      @survey_answers.each do |survey_answer|
        score = survey_answer.survey.scores.first
          report = ScoreReport.new
          report.result = score && score.no_unanswered(survey_answer) || "&nbsp;"
          report.percentile = "&nbsp;"
          @unanswered << report #ScoreReport.new({:result => score.no_unanswered(survey_answer), :percentile => "&nbsp;"})
      end

      # calculate scores for all scales, for all survey answers
      @scales = ScoreScale.find(:all, :order => :position)

      @scales.each do |scale|
        cols = []           # holds columns of results
        # score_names = []  # holds names of score_items
        @survey_answers.each do |survey_answer|
          scores = survey_answer.survey.scores.select { |s| s.score_scale_id == scale.id }.sort_by { |s| s.position }

          # add columns of score results
          cols << scores.map { |score| score.score_report(survey_answer, @journal) }
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

      @groups << [@unanswered] # add unanswered row
      @group_titles = ScoreScale.all.map {|scale| scale.title}
      @group_titles[0] = ""  # do not show standard title

      # render 'show_report'
    else
      flash[:error] = "Kunne ikke vise scoreberegning. Er du logget ind?"
      redirect_to journals_path
    end
  end

end
