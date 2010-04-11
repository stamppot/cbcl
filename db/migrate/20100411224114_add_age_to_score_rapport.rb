class AddAgeToScoreRapport < ActiveRecord::Migration
  def self.up
    add_column :score_rapports, :age, :integer
    
    ScoreRapport.find_each(:include => [{:survey_answer => {:journal => :person_info} }]) {|sr| sr.age = sr.survey_answer.journal.person_info.age; sr.save}
  end

  def self.down
    remove_column :score_rapports, :age
  end
end
