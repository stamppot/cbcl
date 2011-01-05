class CreateCenterSettings < ActiveRecord::Migration
  def self.up
		create_table :center_settings, :force => true do |t|
		  t.integer :center_id
			t.string :settings, :name, :value
		  t.timestamps
		end
  end

  def self.down
		drop_table :center_settings
  end
end