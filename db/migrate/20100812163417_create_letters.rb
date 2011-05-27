class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.integer :group_id
      t.string :name
      t.text :letter
      t.string :surveytype
      t.timestamps
      t.index :group_id
    end
  end

  def self.down
    drop_table :letters
  end
end
