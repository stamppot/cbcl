module SurveyVariables
  # set variable values in survey's question cells. Use vars when they exist, otherwise create a value
  def set_variables
    d = Dictionary.new
    self.questions.each { |question| question.set_variables }
    d.order_by
  end
end