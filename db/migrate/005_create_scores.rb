require 'db/migration_helpers'

class CreateScores < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :score_groups do |t|
      t.column :title, :string
      t.column :description, :text
    end
    
    create_table :score_scales, :force => true do |t|
      t.integer :position
      t.string  :title
    end
    
    create_table :scores, :force => true do |t|
      t.integer  :score_group_id
      t.integer  :survey_id, :null => false
      t.string   :title, :null => false
      t.string   :short_name, :null => false
      t.integer  :sum, :null => false
      t.integer  :scale
      t.integer  :position
      t.integer  :score_scale_id
      t.integer  :items_count
      t.datetime :created_at
      t.datetime :updated_at
      t.index    :survey_id
      t.index    :score_scale_id
    end
    add_foreign_key('scores', 'fk_scores_surveys', 'survey_id', 'surveys', 'id')
    add_foreign_key('scores', 'fk_scores_score_groups', 'score_group_id', 'score_groups', 'id')
  

    create_table :score_items do |t|
      t.column :score_id, :int 
      t.column :question_id, :int
      t.column :items, :text
      t.column :range, :string
      t.column :items, :string
      t.column :qualifier, :int
      t.column :number, :int
      t.index :score_id
    end
    add_foreign_key('score_items', 'fk_score_items_scores', 'score_id', 'scores', 'id')

    create_table :score_refs do |t|
      t.column :score_id, :int
      t.column :gender, :int
      t.column :age_group, :string
      t.column :mean, :float
      t.column :percent95, :int
      t.column :percent98, :int
      t.index :score_id
    end
    add_foreign_key('score_refs', 'fk_score_refs_scores', 'score_id', 'scores', 'id')
    
    create_table "scores_surveys", :id => false, :force => true do |t|
      t.integer "score_id"
      t.integer "survey_id"
    end

    add_index "scores_surveys", ["score_id"], :name => "index_scores_surveys_on_score_id"
    add_index "scores_surveys", ["survey_id"], :name => "index_scores_surveys_on_survey_id"
    
    # many-to-many association with surveys
    # a survey can have many scores attached
    # a score can be calculated for multiple surveys, e.g. cbcl
    # create_table :scores_surveys, :id => false do |t|
    #   t.column :score_id, :int
    #   t.column :survey_id, :int
    # end
    # add_index :scores_surveys, [:score_id]
    # add_index :scores_surveys, [:survey_id]
  end

  def self.down
    drop_table :score_refs
    drop_table :score_items
    drop_table :scores
    drop_table :score_groups
  end
end
