class FillExportVariables
  
  # vars = Variable.all.inject({}) {|h, v| h[v.id] = v; h }
  
  def fill_export_journal_info
  end

  def fill_export_variables(journal, survey_answer, variables_by_id)
    # choose table to insert to, for which survey
    result = {:journal_id => journal.id}
    survey_answer.answers.each do |answer|
      answer.answer_cells.each do |a_cell|
        var = variables_by_id[a_cell.variable_id]
        result["#{var.var}"] = a_cell.value_text.blank? && a_cell.value || a_cell.value_text
        result["#{var.var}_datatype"] = var.datatype == "Numeric" && 0 || 1
      end
    end
    result
  end
  
end