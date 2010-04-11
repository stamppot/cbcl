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
  
  # partition in groups of gender and age_group
  def self.partition_groups(score_results)
    # partition in male/female groups
    m,f = score_results.partition {|sr| sr.gender == 1}
    # remove non-female (errors) from female group
    f = f.detect {|f| f.gender == 2}
    
    # group male/female groups by age group
    
    
  end
end