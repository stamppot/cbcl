class JournalInfo < ActiveRecord::Base
  belongs_to :journal
  belongs_to :center
  belongs_to :team
  
  validates_uniqueness_of :journal_id
  
  def to_csv(journal)
  	[ssghafd, ssghnavn, safdnavn, pid, journal.person_info.alt_id, pkoen, palder, pnation, besvarelsesdato, pfoedt].join(";")
  end
end