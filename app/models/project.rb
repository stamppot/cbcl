class Project < ActiveRecord::Base

	belongs_to :center

	has_and_belongs_to_many :journals
	
	validates_associated :center
	validates_presence_of :code
  	validates_presence_of :name

end