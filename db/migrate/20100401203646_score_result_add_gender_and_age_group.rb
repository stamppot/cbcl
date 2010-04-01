class ScoreResultAddGenderAndAgeGroup < ActiveRecord::Migration
  def self.up
    add_column :score_results, :gender, :integer, :null => false
    add_column :score_results, :age_group, :string, :limit => 5, :null => false
    add_column :score_results, :missing, :integer, :default => 0
    remove_column :score_results, :percentile
    
    ScoreResult.all(:include => :score_rapport)
  end

  def self.down
    remove_column :score_results, :missing
    remove_column :score_results, :age_group
    remove_column :score_results, :gender
  end
end
