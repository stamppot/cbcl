class Code < ActiveRecord::Base
  belongs_to :code_book
  belongs_to :item_choice
  belongs_to :question

  def to_s
    "Spg #{question_number} item:#{item} #{variable} #{item_type} : #{description} : #{datatype} : q #{question_id}[#{row}][col]"
  end

  def to_xml(options = {})
    xml = options[:builder] || Builder::XmlMarkup.new
    xml.__send__(:code,
     {:datatype => datatype, :item => item, :variable => variable, :answer_options => item_choice.name}) do |code|
       xml.description code.description
     end
  end

  def fix_parent
    survey = question.survey
    codebook = CodeBook.find_by_survey_id(question.survey_id)
    puts "found codebook: #{codebook.inspect}"
    if codebook
      codebook.codes << self
      self.save

      bad_codebooks = CodeBook.find_all_by_survey_id(question.survey_id)
      bad_codebooks.shift
      bad_codebooks.map &:destroy
    end
    if self.id == 0
      survey = self.question.survey
      codebook = CodeBook.create(:survey => survey, :title => survey.title, :description => survey.description)
      self.code_book = codebook
      self.save
    end
  end
end
