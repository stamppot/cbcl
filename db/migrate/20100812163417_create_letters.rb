class CreateLetters < ActiveRecord::Migration
  def self.up
    # create_table :letters do |t|
    #   t.integer :group_id
    #   t.string :name
    #   t.text :letter
    #   t.string :surveytype
    #   t.timestamps
    # end
    # add_index :letters, :group_id
  end

  def self.down
    # remove_index :letters, :group_id
    # drop_table :letters
  end
end
