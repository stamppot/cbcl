class AddSurveyAnswerIndex < ActiveRecord::Migration
  def self.up
    add_index :survey_answers, :survey_id
  end

  def self.down
    remove_index :survey_answers, :survey_id
  end
end
