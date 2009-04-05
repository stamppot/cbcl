class ScoreRef < ActiveRecord::Base
  belongs_to :score
  belongs_to :survey
    
  def sex_text
    self.genders.invert[self.gender]
  end
  
  def age_range
    years = age_group.split("-")
    return Range.new(years.first.to_f-1, years.last.to_f+1)
  end
  
  def genders
    {
      'Dreng' => 1,
      'Pige' => 2
    }
  end
  
end