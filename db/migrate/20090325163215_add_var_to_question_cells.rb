class AddVarToQuestionCells < ActiveRecord::Migration
  def self.up
    add_column :question_cells, :var, :string
  end

  def self.down
    remove_column :question_cells, :var
  end
end
