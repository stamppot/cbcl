class AddScoreReport < ActiveRecord::Migration
  def self.up
    create_table :score_rapports do |t|
      t.column :title, :string
      t.column :survey_name, :string
      t.column :short_name, :string
      t.column :survey_id, :int
      t.column :survey_answer_id, :int
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
    end
  # attr_accessor :title, :survey_name, :short_name, :score, :scale, :scores, :result, :percentile, :description      
  end

  def self.down
    drop_table :score_rapports
    drop_table :score_results
  end
end
