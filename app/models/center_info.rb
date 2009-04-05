class CenterInfo < ActiveRecord::Base
  belongs_to :center
  
  validates_associated :center
  
end