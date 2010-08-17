class AddScoreTimestamps < ActiveRecord::Migration
  def self.up
    add_timestamps :scores
    Score.all.map {|s| s.created_at = 1.year.ago; s.updated_at = Time.now; s.save }
  end

  def self.down
    remove_timestamps :scores
  end
end
