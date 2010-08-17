class ScoreReportsController < ApplicationController
  
  def create
    puts "score_report create: #{params.inspect}"
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

  # def create
  # 
  #   respond_to do |format|
  #     format.html {
  #       @page_title = "CBCL - Scorerapport"
  #       answers = []
  # 
  #       if params[:answers].blank?
  #         ids = @journal.answered_entries.map &:id
  #         ids = answers.slice(ids.size-3, ids.size) if ids.size > 3
  #         params[:answers] = ids.inject({}) { |h,e| h[e] = 1; h }
  #         puts "ANSWERS: #{params[:answers].inspect}"
  #       end
  # 
  #       entry_ids = []
  #       params[:answers].each { |key, val| entry_ids << key if val.to_i == 1 } # use only checked survey answers
  #       entries = JournalEntry.find(entry_ids, :include => {:survey => {:scores => [:score_items, :score_refs]}})
  #  entries = Journal.find(journal_id).answered_entries.reverse.slice(0,3) if entries.empty?
  #       @journal = Journal.find params[:journal_id]
  #       survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }
  # 
  #       # create survey titles row  # first header is empty, is in corner
  #       @titles = [""] + survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }
  #       # find or create score_rapport
  #       score_rapports = survey_answers.map { |sa| sa.generate_score_rapport }
  # 
  #       @groups = ScoreReport.scores_in_rows(score_rapports)
  #       @groups << [ScoreReport.row_unanswered(score_rapports)]                                                                                       
  #       @group_titles = ScoreScale.all.map {|scale| scale.title}
  #     }
  #     format.pdf {
  #       puts "score_reports/show pdf"
  #       render :template => 'score_reports/show'
  #     }
  #   end
  # 
  # 
  # end
  # 
  # def show
  #   puts "score_report show: #{params.inspect}"
  #   @page_title = "CBCL - Scorerapport"
  #   @journal = Journal.find(params[:journal_id])
  # 
  #   if params[:answers].blank?
  #     ids = @journal.answered_entries.map &:id
  #     ids = answers.slice(ids.size-3, ids.size) if ids.size > 3
  #     params[:answers] = ids.inject({}) { |h,e| h[e] = 1; h }
  #     puts "ANSWERS: #{params[:answers].inspect}"
  #   end
  # 
  #   entry_ids = []
  #   params[:answers].each { |key, val| entry_ids << key if val.to_i == 1 } # use only checked survey answers
  #   entries = JournalEntry.find(entry_ids, :include => {:survey => {:scores => [:score_items, :score_refs]}})
  # 
  #   @journal = Journal.find params[:journal_id]
  #   survey_answers = entries.map { |entry| entry.survey_answer }.sort_by {|sa| sa.survey.position }
  # 
  #   # create survey titles row  # first header is empty, is in corner
  #   @titles = [""] + survey_answers.map { |sa| "#{sa.survey.category} #{sa.survey.age}" }
  #   # find or create score_rapport
  #   score_rapports = survey_answers.map { |sa| sa.score_rapport ||= sa.generate_score_rapport }
  # 
  #   @groups = ScoreReport.scores_in_rows(score_rapports)
  #   @groups << [ScoreReport.row_unanswered(score_rapports)]
  # 
  #   @group_titles = ScoreScale.all.map {|scale| scale.title}
  # 
  #   respond_to do |format|
  #     format.html { }
  #     format.pdf { 
  #       puts "score_reports/show pdf"
  #       render :template => 'score_reports/show'
  #     }
  #   end
  # end
end
