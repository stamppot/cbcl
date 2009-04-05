module FaqHelper

  def section_text(section)
    return section.title #.gsub(/\<p\>&nbsp;\<\/p\>/, "").gsub(/^\<p\>/, "").gsub(/\<p\>$/, "")
  end

  def question_text(question)
    question.question
    # remove stupid tinyMCE shit
    # return text.gsub(/\<p\>&nbsp;\<\/p\>/, "").gsub(/^\<p\>/, "").gsub(/\<\/p\>$/, "")
  end

  def answer_text(question)
    question.answer
    # remove stupid tinyMCE shit
    # return text.gsub(/\<p\>&nbsp;\<\/p\>/, "").gsub(/^\<p\>/, "").gsub(/\<p\>$/, "")
  end

end