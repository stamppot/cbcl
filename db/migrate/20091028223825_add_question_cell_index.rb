class AddQuestionCellIndex < ActiveRecord::Migration
  def self.up
    # add_index :question_cells, :question_id
    # add_index :answer_cells, :answer_id
  end

  def self.down
    # remove_index :question_cells, :question_id
    # remove_index :answer_cells, :answer_id
  end
end
