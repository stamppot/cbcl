class CenterSetting < ActiveRecord::Base

	belongs_to :center
	validates_presence_of :name, :value, :center
end
