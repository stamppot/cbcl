class AddUpdatedAtToSurveyAnswer < ActiveRecord::Migration
  def self.up
    add_column :score_rapports, :created_at, :datetime
    add_column :score_rapports, :updated_at, :datetime
  end

  def self.down
    remove_column :score_rapports, :updated_at
    remove_column :score_rapports, :created_at
  end
end
