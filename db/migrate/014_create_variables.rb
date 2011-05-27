class CreateVariables < ActiveRecord::Migration
  def self.up
    create_table :variables do |t|
      t.string :var
      t.string :item
      t.integer :row
      t.integer :col
      t.integer :survey_id
      t.integer :question_id      
      t.timestamps
      t.string :datatype

      t.index :survey_id
      t.index :question_id
    end
  end

  def self.down
    drop_table :variables
  end
end
