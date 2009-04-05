class AddCenterInfo < ActiveRecord::Migration
  def self.up
    create_table :center_infos do |t|
      t.integer :center_id
      t.string :street, :zipcode, :city, :telephone, :ean, :person
    end
  end

  def self.down
    drop_table :center_infos
  end
end
