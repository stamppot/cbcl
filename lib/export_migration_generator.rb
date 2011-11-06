class ExportMigrationGenerator
  
  attr_accessor :survey
  
  def initialize(survey)
    self.survey = survey
  end
  
  def build_migration
    migration = create_class_name
    migration += create_up
    migration += create_down
    #migration.join
  end
  
  private 
  
  def create_class_name
    ["class CreateSurveyAnswerExport#{survey.id} < ActiveRecord::Migration;"]
  end
  
  def create_up
    up_method = [" def self.up;\r\n"] 
    up_method += create_table
    up_method << " end;"
  end
    
  def create_down
    down_method = [" def self.down;"] 
    down_method += drop_table
    down_method << " end;"
  end
  
  def table_name
    ":export_survey_answer_#{survey.id}"
  end
  
  def create_table
    table = [" create_table #{table_name} do |t|; "]
    table << "t.integer :survey_answer_id; "
    table << "t.integer :journal_entry_id; "
    table << "t.integer :journal_id; "
    table << "t.integer :center_id; "
    table << "t.datetime :answered_on; "
    indices.each { |i| table << "t.index #{i}; " }
    survey.variables.each do |v|
      datatype = v.datatype == "numeric" ? :integer : :string
      table << "t.#{datatype} :#{v.var}; "
    end
    table << " end;"
    table
  end
  
  def drop_table
    table = [] #remove_indices
    table << "drop_table #{table_name}; end;"
  end
    
  def indices
    [":journal_id", ":center_id"]
  end

  def remove_indices
    indices.map { |i| "remove_index #{table_name}, #{i};"}
  end
end