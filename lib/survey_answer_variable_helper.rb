class SurveyAnswerVariableHelper # TODO: make a module of it
  
  def add_variable_names(survey_answer)
    vars = Variable.all_in_hash(:by => 'question_id')
    
    survey_answer.answers.each do |answer|
      answer_question_id = answer.question_id
      answer.answer_cells.each do |cell|
        variable = vars[answer.question_id][cell.row][cell.col]
        unless variable
          puts "question_id: #{answer.question_id} row: #{cell.row} col: #{cell.col}"
        else
          cell.variable_name = variable.var
        end
      end
      survey_answer
    end
  end
  
end