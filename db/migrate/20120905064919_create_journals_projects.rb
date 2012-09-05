class CreateJournalsProjects < ActiveRecord::Migration
  def self.up
    create_table :journals_projects, :id => false do |t|
      t.integer :journal_id, :project_id, :center_id
      t.string :code, :name, :description
    end
  end

  def self.down
    drop_table :journals_projects
  end
end