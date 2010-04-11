class AddScoreResultsScale < ActiveRecord::Migration
  def self.up
    add_column :score_results, :score_scale_id, :integer
    ScoreResult.all.each do |result|
      result.score_scale_id = result.score.score_scale_id
      result.save
    end
  end

  def self.down
    remove_column :score_results, :score_scale_id
  end
end
