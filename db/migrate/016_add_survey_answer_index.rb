class AddSurveyAnswerIndex < ActiveRecord::Migration
  def self.up
    add_index :survey_answers, :survey_id
    add_index :answer_cells, :answer_id
    add_index :survey_answers, :center_id
    add_index :survey_answers, :age
    add_index :survey_answers, :done
  end

  def self.down
    remove_index :survey_answers, :done
    remove_index :survey_answers, :age
    remove_index :survey_answers, :center_id
    remove_index :answer_cells, :answer_id
    remove_index :survey_answers, :survey_id
  end
end
