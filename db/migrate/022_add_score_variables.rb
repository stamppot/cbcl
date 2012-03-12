class AddScoreVariables < ActiveRecord::Migration
  def self.up
    change_table :scores do |t|
      t.string :variable
      t.string :datatype, :default => 'Numeric'
    end
  end

  def self.down
    change_table :scores do |t|
    end
  end
end