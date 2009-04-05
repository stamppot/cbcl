class ScoreScale < ActiveRecord::Base

  has_many :scores, :order => :position

  acts_as_list


end
