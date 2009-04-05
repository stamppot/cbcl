class ScoreRapport < ActiveRecord::Base
  has_many :score_results, :dependent => :delete_all
  belongs_to :journal_entry
  belongs_to :survey_answer
  belongs_to :survey
  
  
end