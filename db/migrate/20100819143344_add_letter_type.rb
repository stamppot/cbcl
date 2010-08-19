class AddLetterType < ActiveRecord::Migration
  def self.up
    add_column :letters, :surveytype, :string
    add_index :letters, [:group_id, :surveytype], :unique => true)
  end

  def self.down
    remove_column :letters, :surveytype
  end
end
