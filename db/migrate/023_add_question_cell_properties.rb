class AddQuestionCellProperties < ActiveRecord::Migration
  def self.up
    add_column :question_cells, :prop_mask, :integer, :default => 0
  end

  def self.down
    remove_column :question_cells, :prop_mask
  end
end