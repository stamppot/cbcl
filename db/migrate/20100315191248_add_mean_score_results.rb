class AddMeanScoreResults < ActiveRecord::Migration
  def self.up
    add_column :score_results, :mean, :float
    remove_column :score_results, :type

    add_column :score_results, :deviation, :boolean
    add_column :score_results, :percentile_98, :boolean
    add_column :score_results, :percentile_95, :boolean
  end

  def self.down
    remove_column :score_results, :percentile_98
    remove_column :score_results, :percentile_95
    remove_column :score_results, :deviation
    
    add_column :score_results, :type, :string, :limit => 16
    remove_column :score_results, :mean
  end
end
