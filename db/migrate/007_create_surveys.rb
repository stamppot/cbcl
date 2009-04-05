class CreateSurveys < ActiveRecord::Migration
  def self.up
    # read the SQL script
    adapter = ActiveRecord::Base.configurations['development']['adapter']

    schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
    filename = File.join(schema_dir, "cbcl_surveys.sql") #"create.#{adapter}.sql")

    raise "Could not find schema file #{filename}" unless File.exists?(filename)

    fcontent = IO.read(filename)

    # execute the SQL
    puts "Executing SQL script #{filename}"
    # execute SQL statements one by one since execute breaks with MySQL otherwise
    fcontent.split(';').each do |statement|
      execute statement unless statement.empty?
    end
    puts "Complete"
  end

  def self.down
    execute "DROP TABLE `surveys`;"
    execute "DROP TABLE `questions`;"
    execute "DROP TABLE `question_cells`;"
  end
end

#   def self.up
# #    create_table :question_items do |t|
# #      t.column :question_cell_id, :int, :null => false
# #      t.column :qtype, :string, :limit => 30
# #      t.column :value, :text
# #      t.column :position, :int
# #      t.column :text, :text
# #    end
#     create_table :question_cells do |t|
#       t.column :question_id, :int, :null => false
#       t.column :type, :string, :limit => 20
#       t.column :col, :int
#       t.column :row, :int
#       t.column :answer_item, :string, :limit => 5
#       t.column :items, :text
#       t.column :preferences, :string
#     end
#     create_table :questions do |t|
#       t.column :survey_id, :int, :null => false
#       t.column :number, :integer, :unique => true, :null => false
#     end
#     create_table :surveys do |t|
#         t.column :title, :string, :limit => 40
#         t.column :category, :string
#         t.column :description, :text
#         t.column :age, :string
#         t.column :surveytype, :string, :limit => 15
#         t.column :color, :string, :limit => 7
#     end
#   end
# 
#   def self.down  
#     drop_table :question_cells
#     drop_table :questions  
#     drop_table :surveys
#   end
# end
