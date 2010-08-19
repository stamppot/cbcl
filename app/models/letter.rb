class Letter < ActiveRecord::Base
  belongs_to :group
  
  validates_associated :group, :allow_blank => true
  validates_presence_of :letter
  validates_presence_of :name
  
  def self.find_default(roletype)
    Letter.find(:first, :conditions => ['group_id IS NULL or group_id = ? AND surveytype = ?', 0, roletype] )
  end
  
end