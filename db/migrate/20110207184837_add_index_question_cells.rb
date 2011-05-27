class AddIndexQuestionCells < ActiveRecord::Migration
  def self.up
    add_index :question_cells, :question_id
    add_index :question_cells, :row
    add_index :question_cells, :col
    add_index :questions, :survey_id
    add_index :questions, :number
  end

  def self.down
    remove_index :question_cells, :col
    remove_index :question_cells, :row
    remove_index :questions, :number
    remove_index :questions, :survey_id
    remove_index :question_cells, :question_id
  end
end