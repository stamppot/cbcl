require 'facets/dictionary'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class FillExportVariables
  
  def fill_journal_infos
    columns = %w{journal_id ssghafd ssghnavn safdnavn pid pkoen palder pnation dagsdato pfoedt pkoen_datatype palder_datatype pnation_datatype dagsdato_datatype pfoedt_datatype}
    journal_rows = Journal.all.map { |j| j.info.values + [1,0,1,2,2] }
    ExportJournalInfo.import(columns, journal_rows)
  end

  def fill_journal_info(journal)
    columns = %w{journal_id ssghafd ssghnavn safdnavn pid pkoen palder pnation dagsdato pfoedt}
    ExportJournalInfo.import(columns, [journal.info.values], :on_duplicate_key_update => [:dags_dato])
    updated_cells_no = AnswerCell.import(:on_duplicate_key_update => [:value, :value_text])
    
  end
  
  def fill_tables
    variables = Variable.all_in_hash(:by => 'question_id')
    prefixes = Survey.all.map {|s| [s.id, s.prefix]}
    variables_by_prefix = Variable.all(:include => :survey).group_by {|v| v.survey.prefix }
    prefixes.each do |survey_id, prefix|
      puts "fill_tables prefix: #{prefix}"
      update_cols = update_columns(prefix, variables_by_prefix)
      columns = nil
      SurveyAnswer.finished.for_survey(survey_id).find_in_batches do |survey_answers|
        rows = create_rows_params(survey_answers, variables)
        columns ||= rows.first.keys
        fill_table(prefix, columns, update_cols, rows)
      end
    end
  end

  def fill_table(survey_prefix, columns, update_columns, rows_params)
    klass = get_export_answer_class(survey_prefix)
    puts "Columns: #{columns.inspect}"
    rows = rows_params.map {|row_hash| row_hash.values }
    rows.each {|row| puts "Row: #{row.inspect}"}
    klass.import(columns, rows, :on_duplicate_key_update => update_columns)
  end
  
  # Numeric:0, String:1, Date:2
  def fill_export_journal_info(journal)
    result = journal.info
    result.each do |key,value|
      result["key_#{datatype}".to_sym] = 1
    end
    result[:dagsdato_datatype] = 2
    result[:pfoedt_datatype] = 2
  end

  def create_rows_params(survey_answers, variables_by_question_id)
    survey_answers_by_journal = survey_answers.group_by { |sa| sa.journal_id }
    journal_infos = ExportJournalInfo.all(:conditions => ['journal_id in(?)', survey_answers_by_journal.keys], :select => ['id, journal_id'])
    journal_infos_by_journal = journal_infos.group_by { |ji| ji.journal_id }
    survey_answers.map do |sa| 
      journal_info = journal_infos_by_journal[sa.journal_id]
      sa.export_variables_params(journal_info.first, variables_by_question_id)
    end
  end

  def update_columns(survey_prefix, variables)
    puts "update_columns(survey_prefix: #{survey_prefix})"
    variables[survey_prefix].map { |var| var.var }
  end

    # choose table to insert to, for which survey. Params arg is parameters for one row in an export_variables_survey_xx table

  def get_export_answer_class(survey_prefix)
    klass = case survey_prefix
    when "cc" : ExportVariablesCcAnswer
    when "ccy": ExportVariablesCcyAnswer
    when "ct" : ExportVariablesCtAnswer
    when "tt" : ExportVariablesTtAnswer
    when "ycy": ExportVariablesYcyAnswer
    end
  end
    
end
