class ScoreScales < ActiveRecord::Migration
  def self.up
    create_table :score_scales do |t|
      t.integer :position
      t.string :title
    end
    add_column :scores, :score_scale_id, :int
  end

  def self.down
    remove_column :scores, :score_scale_id
    drop_table :score_scales
  end
end
