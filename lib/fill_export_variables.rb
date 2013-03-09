# require 'facets/dictionary'
require 'hashery'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class FillExportVariables
  
  def generate_export_variables_answer(survey_answer)
    vars = Variable.for_survey(survey_answer.survey_id).all
    fill_all_tables([survey_answer], vars)
  end
  
  # def fill_journal_infos
  #   columns = %w{journal_id ssghafd ssghnavn safdnavn pid pkoen palder pnation dagsdato pfoedt pkoen_datatype palder_datatype pnation_datatype dagsdato_datatype pfoedt_datatype}
  #   numeric, string, date = 0, 1, 2
  #   journal_rows = Journal.all.map { |j| j.info.values + [string,numeric,string,date,date] }
  #   ExportJournalInfo.import(columns, journal_rows)
  # end

  # def fill_journal_info(journal)
  #   columns = %w{journal_id ssghafd ssghnavn safdnavn pid pkoen palder pnation dagsdato pfoedt}
  #   ExportJournalInfo.import(columns, [journal.info.values], :on_duplicate_key_update => [:dags_dato])
  #   updated_cells_no = AnswerCell.import(:on_duplicate_key_update => [:value, :value_text])
  # end
      
  def fill_all_tables(survey_answers = nil, variables = nil)
    variables ||= Variable.all
    variables_by_survey_id = variables.group_by {|v| v.survey_id}

    if survey_answers
      fill_tables(survey_answers, variables_by_survey_id)
    else
      SurveyAnswer.finished.find_in_batches(:batch_size => 200) do |survey_answers|
        fill_tables(survey_answers, variables_by_survey_id)
      end
    end
  end

  def fill_tables(survey_answers, variables_by_survey_id)
    survey_buckets = survey_answers.group_by {|sa| sa.survey_id}
    survey_buckets.each do |prefix, survey_answers|
      new_rows, update_rows = create_rows_params(survey_answers, variables_by_survey_id)
      if new_rows.any?
        fill_table(prefix, new_rows)
      end
      if update_rows && update_rows.any?
        # instead of updating row, do the simple thing: delete it and reinsert with same id
        update_rows.each { |h| get_export_answer_class(prefix).destroy(h[:id]) }
        fill_table(prefix, update_rows)
      end
    end
  end
  
  def fill_table(survey_prefix, rows_params, options = {})
    klass = get_export_answer_class(survey_prefix)
    columns = rows_params.first.keys
    rows = rows_params.map {|row_hash| row_hash.values }
    klass.import(columns, rows, options)
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

  def create_rows_params(survey_answers, variables_by_survey_id)
    survey_answers_by_journal = survey_answers.group_by &:journal_id
    journal_infos = ExportJournalInfo.all(:conditions => ['journal_id in(?)', survey_answers_by_journal.keys], :select => ['id, journal_id'])
    journal_infos_by_journal = journal_infos.group_by { |ji| ji.journal_id }
    new_rows = []
    update_rows = []
    survey_answers.each do |survey_answer| 
      journal_info = journal_infos_by_journal[survey_answer.journal_id]
      # "looking for existing export_variable_answer: journal_id #{survey_answer.journal_id} survey_answer_id: #{survey_answer.id}"
      if exists = get_export_answer_class(survey_answer.survey_id).exists(survey_answer)
        puts "export_variable_answer exists: journal_id #{survey_answer.journal_id} survey_answer_id: #{survey_answer.id}  exists: #{exists.inspect}"
        vars_for_survey = variables_by_survey_id[survey_answer.survey_id]
        puts "vars_for_survey (#{survey_answer.survey_id}): #{vars_for_survey.size} #{vars_for_survey.class}"
        update_rows << survey_answer.export_variables_params(journal_info.first, exists.id, variables_by_survey_id[survey_answer.survey_id])
      else
        new_rows << survey_answer.export_variables_params(journal_info.first, variables_by_survey_id[survey_answer.survey_id])
      end
    end
    [new_rows, update_rows]
  end

  # def create_row_params(survey_answer, variables)
  #   journal_info = ExportJournalInfo.find_by_journal_id(survey_answer.journal_id, :select => ['id, journal_id'])
  #   params = if exists = get_export_answer_class(survey_answer.survey_id).exists(survey_answer)
  #     sa.export_variables_params(journal_info, exists.id, variables)
  #   else
  #     sa.export_variables_params(journal_info.first, variables_by_survey_id[sa.survey_id])
  #   end
  # end

  def destroy_existing_rows!(survey_prefix, rows)
    puts "destroy rows: #{rows.inspect}"
    rows.each { |h| get_export_answer_class(survey_prefix).destroy(h[:id]) }
  end
    
  def update_columns(survey_prefix, variables)
    puts "update_columns(survey_prefix: #{survey_prefix})"
    variables[survey_prefix].map { |var| var.var }
  end

    # choose table to insert to, for which survey. Params arg is parameters for one row in an export_variables_survey_xx table

  def get_export_answer_class(survey_prefix)
    klass = case survey_prefix
    when 1: ExportVariablesCcAnswer
    when 2: ExportVariablesCcyAnswer
    when 3: ExportVariablesCtAnswer
    when 4: ExportVariablesTtAnswer
    when 5: ExportVariablesYcyAnswer
    when "cc" : ExportVariablesCcAnswer
    when "ccy": ExportVariablesCcyAnswer
    when "ct" : ExportVariablesCtAnswer
    when "tt" : ExportVariablesTtAnswer
    when "ycy": ExportVariablesYcyAnswer
    end
  end
    
end
