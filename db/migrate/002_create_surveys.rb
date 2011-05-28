require 'db/migration_helpers'

class CreateSurveys < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up

    create_table :surveys, :force => true do |t|
      t.string  :title,       :limit => 40
      t.string  :category
      t.text    :description
      t.string  :age
      t.string  :surveytype,  :limit => 15
      t.string  :color,       :limit => 7
      t.integer :position,                  :default => 99
    end

    create_table :questions, :force => true do |t|
      t.integer :survey_id,     :null => false
      t.integer :number,        :null => false
      t.integer :ratings_count
      t.index :survey_id
      t.index :number
    end
    add_foreign_key('questions', 'fk_questions_surveys', 'survey_id', 'surveys', 'id')
    
    create_table :question_cells, :force => true do |t|
      t.integer :question_id,               :null => false
      t.string  :type,        :limit => 20
      t.integer :col
      t.integer :row
      t.string  :answer_item, :limit => 5
      t.text    :items
      t.string  :preferences
      t.string  :var
      t.string  :datatype, :limit => 8
      t.index   :question_id
    end
    add_foreign_key('question_cells', 'fk_question_cells_questions', 'question_id', 'questions', 'id')

    end
    
  #   # read the SQL script
  #   adapter = ActiveRecord::Base.configurations['development']['adapter']
  # 
  #   schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
  #   filename = File.join(schema_dir, "cbcl_surveys.sql") #"create.#{adapter}.sql")
  # 
  #   raise "Could not find schema file #{filename}" unless File.exists?(filename)
  # 
  #   fcontent = IO.read(filename)
  # 
  #   # execute the SQL
  #   puts "Executing SQL script #{filename}"
  #   # execute SQL statements one by one since execute breaks with MySQL otherwise
  #   fcontent.split(';').each do |statement|
  #     execute statement unless statement.empty?
  #   end
  #   puts "Complete"
  # end
  # 
  # def self.down
  #   execute "DROP TABLE `surveys`;"
  #   execute "DROP TABLE `questions`;"
  #   execute "DROP TABLE `question_cells`;"
  # end

  def self.down  
    drop_table :question_cells
    drop_table :questions  
    drop_table :surveys
  end
end
