class QuestionItem

  attr_accessor :qtype, :value, :text, :position
  
  def initialize
    @qtype = ""
    @value = ""
    @text = ""
    @position = 1
  end
  
  def to_db
    out = ""
    out << @qtype unless @qtype.nil?
    out << "::"
    out << @value unless @value.nil?
    out << "::"
    out << @text unless @text.nil?
    return out
  end

  # comparison based on position
  def <=>(other)
    @position <=> @position
  end
  
  def to_xml2
    xml = []
    xml << "<question_item id='#{self.id.to_s}' >"
    xml << "  <qtype>#{self.qtype}</qtype>"
    xml << "  <value>#{self.value}</value>"
    xml << "  <text>#{self.text}</text>"
    xml << "  <position>#{self.position.to_s}</position>"
    xml << "</question_item>"
    return xml.join("\n")
  end
end

