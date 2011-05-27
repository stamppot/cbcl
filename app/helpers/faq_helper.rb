module FaqHelper

  def section_text(section)
    return section.title
  end

  def question_text(question)
    question.question
  end

  def answer_text(question)
    question.answer
  end

end