class ExportAnswers

  attr_accessor :id, :journal_id, :survey_id, :columns
  
  def initialize(survey_id, journal_id, columns)
    self.survey_id = survey_id
    self.journal_id = journal_id
    self.columns = columns
  end
  
  def self.collect_data_and_datatypes(survey)
    survey_id = survey.is_a?(Survey) && survey.id || survey
    rows = ActiveRecord::Base.connection.execute("select * from #{table_name(survey_id)}")
    fields = rows.fetch_fields.map {|f| f.name}
    vars = prepare_variables(survey)
    results = []
    
    rows.each do |row|
      row = field_data_collection = fields.zip(row)
      # puts "row with var: #{row.inspect}"
      row = add_datatypes(row, vars)
      results << ExportAnswers.new(survey_id, detect_journal_id(row), row)
    end
    results
  end

  def self.prepare_variables(survey)
    vars = Variable.for_survey(1).all
    var_map = vars.inject({}) { |col, v| col[v.var.to_sym] = v.datatype; col}
  end
  
  def self.add_datatypes(row, vars)
    row.each do |pair| 
      if !pair.blank?
        var = pair.first
        pair << vars[var.to_sym]
      end
    end  
  end
  
  def self.detect_journal_id(row)
    row.detect {|col| col.first == "journal_id"}.second
  end
  
  def self.get_export_journal_info(journal)
    ExportJournalInfo.find_by_journal_id(journal.is_a?(Journal) && journal.id || journal)
  end
  
  private 
  def self.table_name(survey_id)
    "export_variables_#{VAR_PREFIX[survey_id]}_answers"
  end

  VAR_PREFIX = { 1 => "cc", 2 => "ccy", 3 => "ct", 4 => "tt", 5 => "ycy"}
end

ea = ExportAnswers.new