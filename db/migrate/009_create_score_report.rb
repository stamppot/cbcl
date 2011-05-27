class CreateScoreReport < ActiveRecord::Migration
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
      t.column :age_group, :string, :limit => 5, :null => false
      t.column :age, :integer
      t.column :center_id, :integer, :limit => 4
      t.index  :center_id
      t.index :survey_answer_id
    end
    
    create_table :score_results do |t|
      t.column :score_rapport_id, :int
      t.column :survey_id, :int
      t.column :score_id, :int
      t.column :result, :int
      t.column :percentile, :string
      t.column :scale, :int
      t.column :title, :string
      t.column :type, :string
      t.column :position, :int
      t.column :score_scale_id, :integer
      t.column :missing_percentage, :float
      t.column :hits, :integer
      t.column :valid_percentage, :boolean
      
      t.index  :score_rapport_id
      t.index  :score_id
      t.index  [:score_id, :score_rapport_id]
    end
  end

  def self.down
    drop_table :score_rapports
    drop_table :score_results
  end
end
