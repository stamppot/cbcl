require 'db/migration_helpers'

class CreateCenterInfo < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :center_infos do |t|
      t.integer :center_id
      t.string :street, :zipcode, :city, :telephone, :ean, :person
      t.index :center_id
    end
    add_foreign_key('center_infos', 'fk_center_infos_centers', 'center_id', 'groups', 'id')
  end

  def self.down
    drop_table :center_infos
  end
end
