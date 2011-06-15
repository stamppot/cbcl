class FillAnswerCellsVariable
  
  def fill
    vars = Variable.all_in_hash(:by => 'question_id')
    # columns = [:answer_id, :row, :col, :item, :rating, :value_text, :text, :cell_type, :value, :variable_id]
    columns = [:id, :variable_id]
    
    Answer.find_in_batches(:batch_size => 50, :include => :answer_cells) do |answers|
      answers.each { |a| fill_answer(a, vars, columns) }
    end
  end
  
  def fill_answer(answer, variables, columns = [:id, :variable_id])
    a = answer
    vv = variables[a.question_id]
    if !vv
      puts "variables: for question_id #{a.question_id} is nil for answer #{a.id}" 
      next
    end
    a_cells = a.answer_cells.map do |ac|
      next if ac.variable_id
      
      if !vv.key?(ac_row) || vv[ac.row].key?(ac.col)
        puts "answer: #{a.id} var missing for row or col [#{a.question_id}][#{ac.row}][#{ac.col}] is nil" 
        next
      end
      ac.variable_id = vv[ac.row][ac.col][:id]
      [ac.id, ac.variable_id]
    end
    AnswerCell.import(columns, a_cells.compact, :on_duplicate_key_update => [:variable_id])
  end
end