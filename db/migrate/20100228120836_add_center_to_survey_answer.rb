class AddCenterToSurveyAnswer < ActiveRecord::Migration
  def self.up
    add_column :survey_answers, :center_id, :integer
    SurveyAnswer.all.each do |sa|
      if sa.journal_id.nil?
        sa.journal_id = sa.journal_entry.journal_id
      end
      if sa.center_id.nil?
        sa.center_id = sa.journal.center_id
        sa.save
      end
    end
  end

  def self.down
    remove_column :survey_answers, :center_id
  end
end
