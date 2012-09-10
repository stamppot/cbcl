class AddPersonInfoAltId < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :project_id, :string
    add_column :person_infos, :parent_name, :string
  end

  def self.down
    remove_column :person_infos, :project_id
    remove_column :person_infos, :parent_name
  end
end