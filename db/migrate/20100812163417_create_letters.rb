class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.integer :group_id
      t.string :name
      t.text :letter
      t.timestamps
    end
    add_index :group_id

  end

  def self.down
    drop_table :letters
  end
end
