class JournalInfo < ActiveRecord::Base
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  
  validates_uniqueness_of :journal_id
  
end