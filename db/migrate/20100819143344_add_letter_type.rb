class AddLetterType < ActiveRecord::Migration
  def self.up
    add_column :letters, :surveytype, :string
  end

  def self.down
    remove_column :letters, :surveytype
  end
end
