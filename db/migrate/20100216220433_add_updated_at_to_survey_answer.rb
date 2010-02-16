class AddUpdatedAtToSurveyAnswer < ActiveRecord::Migration
  def self.up
    add_column :survey_answers, :updated_at, :datetime
    add_column :journal_entries, :updated_at, :datetime
    add_column :score_rapports, :created_at, :datetime
    add_column :score_rapports, :updated_at, :datetime
  end

  def self.down
    remove_column :score_rapports, :updated_at
    remove_column :score_rapports, :created_at
    remove_column :journal_entries, :updated_at
    remove_column :survey_answers, :updated_at
  end
end
