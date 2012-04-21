class ScoreReport
  
  attr_accessor :title, :survey_name, :short_name, :score, :scale, :scores, :result, :percentile, :description
  
  def initialize
    @scores = []
    @survey_name = ""
    @short_name = ""
    @result = 0
    @scale = 0
    @title = ""
    @percentile = ""
    @description = ""
  end

  def self.build(survey_answer)
    rapport = survey_answer.score_rapport
    report = ScoreReport.new
    report.title = self.title
    report.score = self
    report.scale = self.score_scale.position - 1 # used to generate ids to hide score group
    report.short_name = self.short_name
    results = self.calculate(survey_answer)
    report.result = results[0]
    report.percentile = Score.percentile_string(results[1], results[2])
    return report
  end
  
  def to_s
    if @score.nil?
      @description = 'link'
      "<div class='scale_title'>#{@title}</div><a class='show_hide' ><img border='0' src='/images/icon_show_hide.png' ></a>"
    else
      @result.to_s
    end
  end
  
  # combines a row of score reports to one report
  def combine(row)
    self.scores = row.map { |cell| cell.score }
    return [self]
  end
  
  def self.row_unanswered(score_rapports)
    unanswered = ["Ubesvarede"]
    score_rapports.each do |score_rapport|
      if score_rapport.unanswered > 100  # temporary, recalculate for wrong values
        score_rapport.unanswered = score_rapport.survey_answer.no_unanswered
        score_rapport.save
      end
      report = ScoreReport.new
      report.result = score_rapport.unanswered
      report.percentile = "&nbsp;"
      unanswered << report
    end
    unanswered
  end
  
  def self.scores_in_rows(score_rapports)
    scales = ScoreScale.find(:all, :order => :position)
    scales.map do |scale|
      # get result columns
      cols = score_rapports.map do |score_rapport| # get scores for current scale
        score_results = score_rapport.score_results.select { |s| s.score_scale_id == scale.id }.sort_by { |s| s.position }
        score_results.map { |result| result.to_report }
      end

      rows = cols.fill_2d.transpose
      # add header and left column of score titles
      score_names = rows.map { |row| row.detect {|r| r}.title }
      # insert score title (from first of each column)
      rows.each { |row| row.insert(0, score_names.shift) }  # insert score_item names in first column
    end
  end
end
