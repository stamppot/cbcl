class ScoreResult < ActiveRecord::Base
  belongs_to :score_rapport
  belongs_to :survey  # :through => :journal_entry
  
end