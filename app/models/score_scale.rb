class ScoreScale < ActiveRecord::Base
  has_many :scores, :order => :position
  has_many :score_rapports
  acts_as_list
end
