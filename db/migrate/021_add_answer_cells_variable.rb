class AddAnswerCellsVariable < ActiveRecord::Migration
  def self.up
    add_column :answer_cells, :variable_id, :integer, :limit => 2
    add_index :answer_cells, :variable_id
    remove_timestamps :variables
  end
  
  def self.down
    add_timestamps :variables
    remove_index :answer_cells, :variable_id
    remove_column :answer_cells, :variable_id
  end
end