class ScoreResultAddGenderAndAgeGroup < ActiveRecord::Migration
  def self.up
    add_column :score_rapports, :gender, :integer, :null => false
    add_column :score_rapports, :age_group, :string, :limit => 5, :null => false
    add_column :score_rapports, :age, :integer
    
    ScoreRapport.find_each(:include => [{:survey_answer => {:journal => :person_info} }]) do |sr|
      s = sr.score_results.first; sr.gender = s.gender; sr.age_group = s.age_group
      sr.age = sr.survey_answer.journal.person_info.age; sr.save
    end
    # add_column :score_results, :missing, :integer, :default => 0
    # remove_column :score_results, :percentile
    # 
    # ScoreRapport.find_each {|sr| s = sr.score_results.first; sr.gender = s.gender; sr.age_group = s.age_group; sr.save}
  end

  def self.down
    # remove_column :score_results, :missing
    # remove_column :score_results, :age_group
    # remove_column :score_results, :gender
  end
end
