require 'db/migration_helpers'

class CreateScoreReport < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :score_rapports do |t|
      t.column :title, :string
      t.column :survey_name, :string
      t.column :short_name, :string
      t.column :survey_id, :int
      t.column :survey_answer_id, :int
      t.column :unanswered, :integer
      t.column :gender, :integer, :null => false
      t.column :age_group, :string, :limit => 5, :null => false
      t.column :age, :integer
      t.column :gender, :integer, :null => false
      # t.column :age_group, :string, :limit => 5, :null => false
      t.column :age, :integer
      t.column :center_id, :integer, :limit => 4
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.index  :center_id
      t.index :survey_answer_id
    end
    add_foreign_key('score_rapports', 'fk_score_rapports_survey_answers', 'survey_answer_id', 'survey_answers', 'id')
    add_foreign_key('score_rapports', 'fk_score_rapports_centers', 'center_id', 'groups', 'id')
    
    create_table :score_results do |t|
      t.column :score_rapport_id, :int
      t.column :survey_id, :int
      t.column :score_id, :int
      t.column :result, :int
      t.column :percentile, :string
      t.column :scale, :int
      t.column :title, :string
      t.column :position, :int
      t.column :score_scale_id, :integer
      t.column :missing, :integer, :default => 0
      t.column :missing_percentage, :float
      t.column :hits, :integer
      t.column :valid_percentage, :boolean
      t.column :mean, :float
      t.column :deviation, :boolean
      t.column :percentile_98, :boolean
      t.column :percentile_95, :boolean
      
      t.index  :score_rapport_id
      t.index  :score_id
      t.index  :survey_id
      t.index  [:score_id, :score_rapport_id]
    end
    add_foreign_key('score_results', 'fk_score_results_score_rapports', 'score_rapport_id', 'score_rapports', 'id')
    
  end

  def self.down
    drop_table :score_results if table_exists? :score_results
    drop_table :score_rapports if table_exists? :score_rapports
  end
end
