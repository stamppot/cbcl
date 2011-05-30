require 'db/migration_helpers'

class CreateLetters < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :letters do |t|
      t.integer :group_id
      t.string :name
      t.text :letter
      t.string :surveytype
      t.timestamps
      t.index :group_id
    end
    add_foreign_key('letters', 'fk_letters_groups', 'group_id', 'groups', 'id')
  end

  def self.down
    drop_table :letters if table_exists? :letters
  end
end
