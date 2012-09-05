class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects, :force => true do |t|
      t.string :code, :name, :description
      t.int :center_id
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end