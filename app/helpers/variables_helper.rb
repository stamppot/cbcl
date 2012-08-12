module VariablesHelper

  def survey_options
    # @survey = Survey.first
    Survey.all.collect do |survey|
      [survey.get_title, survey.id]
    end
  end

  def question_options(survey_id)
    survey = Survey.and_q.find(survey_id)
    questions = survey.questions.map do |question|
      [question.number.to_roman, question.id]
    end
  end

  # def question_options(survey_id)
  #   Survey.find(survey_id).questions.collect do |question|
  #     [question.number.to_roman, question.id]
  #   end
  # end

  # return no. rows for this question
  def row_options(question)
    question.question_cells.select { |cell| cell.type =~ /Rating|TextBox|Comment/ }.collect do |cell|
      [cell.row, cell.row]
    end
  end

  # return no. rows for this question
  def col_options(question)
    question.question_cells.select { |cell| cell.type =~ /Rating|TextBox|Comment/ }.collect do |cell|
      [cell.col, cell.col]
    end
  end
  
end
