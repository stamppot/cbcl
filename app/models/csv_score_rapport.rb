require 'fastercsv'

class CsvScoreRapport < ActiveRecord::Base  
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["csv_score_rapports.survey_id = ?", survey_id] } }
  named_scope :for_center, lambda { |center_id| { :conditions => ["csv_score_rapports.center_id = ?", center_id] } }
  named_scope :for_team, lambda { |team_id| { :conditions => ["csv_score_rapports.team_id = ?", team_id] } }
  
end