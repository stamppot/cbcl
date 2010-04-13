class AddHitsCountToScoreResult < ActiveRecord::Migration
  def self.up
    add_column :score_results, :answered_items, :string, :limit => 255
    add_column :score_results, :hits, :integer
  end

  def self.down
    remove_column :score_results, :answered_items
    remove_column :score_results, :hits
  end
end
