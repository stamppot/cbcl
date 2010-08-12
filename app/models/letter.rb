class Letter < ActiveRecord::Base
  belongs_to :group
  
  validates_presence_of :group
  validates_presence_of :letter
  validates_presence_of :name
  
end
