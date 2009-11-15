class CsvAnswer < ActiveRecord::Base
  belongs_to :survey_answer
  belongs_to :survey
  belongs_to :journal_entry
  belongs_to :journal
  
  named_scope :by_survey_answer, lambda { |id| { :conditions => ['survey_answer_id = ?', id], :limit => 1 } }
  named_scope :by_journal_and_surveys, lambda { |j_id, survey_ids| { :conditions => ['journal_id = ? and survey_id IN (?)', j_id, survey_ids], :limit => survey_ids.size, :order => 'survey_id' } }  
end