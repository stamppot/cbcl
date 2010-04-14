class AddPercValidToScoreResult < ActiveRecord::Migration
  def self.up
    add_column :score_results, :valid_percentage, :boolean
  end

  def self.down
    remove_column :score_results, :valid_percentage
  end
end
