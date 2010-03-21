class AddMeanScoreResults < ActiveRecord::Migration
  def self.up
    add_column :score_results, :mean, :float
    remove_column :score_results, :type
  end

  def self.down
    add_column :score_results, :type, :string, :limit => 16
    remove_column :score_results, :mean
  end
end
