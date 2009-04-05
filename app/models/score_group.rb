# a group of scores, fx for all CBCL surveys. Handy when more types of surveys are added
class ScoreGroup < ActiveRecord::Base
  has_many :scores
  
  def position
    self.scores.find_by_title()
  end
  
end
