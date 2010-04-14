class AddCenterToScoreRapport < ActiveRecord::Migration
  def self.up
    add_column :score_rapports, :center_id, :integer, :limit => 4
  end

  def self.down
    remove_column :score_rapports, :center_id
  end
end
