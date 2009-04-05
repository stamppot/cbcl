class CreateScores < ActiveRecord::Migration
  def self.up

    create_table :score_groups do |t|
      t.column :title, :string
      t.column :description, :text
    end
    
    create_table :scores do |t|
      t.column :score_group_id, :int
      t.column :survey_id, :int
      t.column :title, :string
      t.column :short_name, :string
      t.column :sum, :int
      t.column :scale, :int
      t.column :position, :int
    end
    
    create_table :score_items do |t|
      t.column :score_id, :int 
      t.column :question_id, :int
      t.column :items, :text
      t.column :range, :string
      t.column :items, :string
      t.column :qualifier, :int
      t.column :number, :int
    end

    create_table :score_refs do |t|
      t.column :score_id, :int
      # t.column :survey_id, :int # deprecated
      t.column :gender, :int
      t.column :age_group, :string
      t.column :mean, :float
      t.column :percent95, :int
      t.column :percent98, :int
    end
      
    # many-to-many association with surveys
    # a survey can have many scores attached
    # a score can be calculated for multiple surveys, e.g. cbcl
    # create_table :scores_surveys, :id => false do |t|
    #   t.column :score_id, :int
    #   t.column :survey_id, :int
    # end
    # add_index :scores_surveys, [:score_id]
    # add_index :scores_surveys, [:survey_id]
    add_index :score_items, :score_id
    add_index :score_refs, :score_id
  end

  def self.down
    remove_index :score_items, :score_id
    remove_index :score_refs, :score_id
    drop_table :score_refs
    drop_table :score_items
    drop_table :scores
    drop_table :score_groups
    # drop_table :scores_surveys
  end
end
