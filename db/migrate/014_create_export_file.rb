class CreateExportFile < ActiveRecord::Migration
  def self.up
    create_table :export_files do |t|
      t.column :filename, :string
      t.column :content_type, :string
      t.column :thumbnail, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :export_files
  end
end
