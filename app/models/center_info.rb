class CenterInfo < ActiveRecord::Base
  belongs_to :center

  validates_presence_of :center_id
  validates_associated :center
  
end