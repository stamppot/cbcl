class AddPersonInfoAltId < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :project_id, :string
  end

  def self.down
    remove_column :person_infos, :project_id
  end
end