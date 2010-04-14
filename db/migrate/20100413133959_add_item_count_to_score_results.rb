class AddItemCountToScoreResults < ActiveRecord::Migration
  def self.up
    add_column :score_results, :missing_percentage, :float
  end

  def self.down
    remove_column :score_results, :missing_percentage
  end
end
