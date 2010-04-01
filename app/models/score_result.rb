class ScoreResult < ActiveRecord::Base
  belongs_to :score_rapport
  belongs_to :survey
  belongs_to :score_scale
  belongs_to :score

  attr_accessor :standard_deviation
  
  def to_report
    report = ScoreReport.new
    report.title = self.title
    # report.score = self.score
    report.scale = self.position - 1 # used to generate ids to hide score group
    report.short_name = self.score_rapport.short_name
    # results = survey_answer.score_rapport # self.calculate(survey_answer)
    report.result = self.result
    percent = 
    if self.percentile_98
      :percentile_98
    elsif self.percentile_95
      :percentile_95
    elsif self.deviation
      :deviation
    else
      :normal
    end
    report.percentile = Score.percentile_string(percent, self.mean)
    return report
  end
  
end