class AddItemNoToScores < ActiveRecord::Migration
  def self.up
    add_column :scores, :items_count, :integer
    Score.all.map { |s| s.set_items_count }
  end

  def self.down
    remove_column :scores, :items_count
  end
end
