class AddSurveyAnswerTimestamps < ActiveRecord::Migration
  def self.up
    add_column :survey_answers, :journal_id, :integer    
    add_index :survey_answers, :journal_id
      
    SurveyAnswer.find_each do |sa|
      if sa.journal_entry
        sa.journal_id = sa.journal_entry.journal_id 
        sa.save
      else
        sa.destroy if sa.answers.empty? && sa.answers.empty? # cleanup survey_answers without a journal_entry
      end
    end
  end

  def self.down
    remove_index :survey_answers, :journal_id
    remove_column :survey_answers, :journal_id
    remove_column :survey_answers, :updated_at
    remove_column :survey_answers, :created_at
  end
end
