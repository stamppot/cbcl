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
    end
    add_index :variables, :survey_id
    add_index :variables, :question_id
  end

  def self.down
    remove_index :variables, :survey_id
    remove_index :variables, :question_id
    drop_table :variables
  end
end
