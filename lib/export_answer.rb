class ExportAnswer

  attr_accessor :prefix, :id, :journal_id, :survey_id, :columns, :columns_cc, :columns_ccy, :columns_cc, :columns_tt, :columns_ycy
  
  def initialize(survey_id, journal_id, columns)
    self.prefix = VAR_PREFIX[survey_id]
    self.survey_id = survey_id
    self.journal_id = journal_id
    self.columns = columns
    # send("columns_#{prefix}", columns)
  end
  
  # def combine(rhs)
  #   if self.journal_id == rhs.journal_id
  #     self.columns << rhs.columns[4..-1]
  #   end
  # end
  # 
  # def self.combine(array_of_export_answers)
  #   a = array_of_export_answers.shift
  # end
    
  def self.collect_data_and_datatypes(survey)
    survey_id = survey.is_a?(Survey) && survey.id || survey
    rows = ActiveRecord::Base.connection.execute("select * from #{table_name(survey_id)}")
    fields = rows.fetch_fields.map {|f| f.name}
    vars = prepare_variables(survey)
    results = []
    
    rows.each do |row|
      row = fields.zip(row)
      row = add_datatypes(row, vars)
      results << self.new(survey_id, detect_journal_id(row), row)
    end
    results
  end

  private
  
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
  
  # def self.get_export_journal_info(journal)
  #   ExportJournalInfo.find_by_journal_id(journal.is_a?(Journal) && journal.id || journal)
  # end

  #SELECT * FROM export_journal_infos ji inner join export_answer_cc_variables cc ON cc.journal_id = ji.journal_id inner join export_answer_ccy_variables ccy ON ccy.journal_id = ji.journal_id inner join export_answer_ct_variables ct ON ct.journal_id = ji.journal_id;  
  def join_query
    prefixes = Survey.all.map &:prefix
    query = ["select * from export_journal_infos ji, "] << prefixes.map {|prefix| "export_variables_#{prefix}_answers" }
    prefixes.each do |prefix|
      query << "where export_variables_#{prefix}_answers. #{prefix} on #{prefix}.journal_id = ji.journal_id "
      # query << "inner join export_variables_#{prefix}_answers #{prefix} on #{prefix}.journal_id = ji.journal_id "
    end
    query
  end
  
  private 
  def self.table_name(survey_id)
    "export_variables_#{VAR_PREFIX[survey_id]}_answers"
  end

  VAR_PREFIX = { 1 => "cc", 2 => "ccy", 3 => "ct", 4 => "tt", 5 => "ycy"}
end

