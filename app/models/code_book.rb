class CodeBook < ActiveRecord::Base
  has_many :codes
  belongs_to :survey
  
  def to_hash
    result = "#{self.title} - #{self.description}\n"
    code_strings = codes.map do |code|
      line = {
        :survey_title => self.title,
        :survey_description => self.description,
        :question => code.question_number,
        :item => code.item, 
        :variable => code.variable,
        :measurement_level => code.measurement_level,
        :description => code.description,
        :datatype => code.datatype,
        :no_options => code.item_choice.no_options
      }
      option_no = 1
      line[:options] = code.item_choice.item_options.map() do |option|
          { :option => option.option,
          :code => option.code,
          :label => option.label
        }
      end
      line
    end
    code_strings
  end
  
  def to_xml(options = {})
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new
      #xml.instruct!
      xml.__send__(:codebook, {:survey => self.survey.title, :description => self.survey.description}) do
        xml.codes do |codes_elem|
          self.codes.each do |code|
            attrs = {:datatype => code.datatype, :item => code.item, :variable => code.variable, 
              :answer_options => code.item_choice.name,
              :description => code.description}
            xml.__send__(:code, attrs)
          end
        end
        item_choices = self.codes.map {|c| c.item_choice}.uniq
        xml.answer_values do |answer_values|
          item_choices.each do |item_choice|
            attrs = {:name => item_choice.name, :datatype => item_choice.datatype, :no_options => item_choice.no_options}
            xml.__send__(:options, attrs) do
              item_choice.item_options.each do |option|
                xml.option option.option
                xml.code option.code
                xml.label option.label 
              end
            end
          end
        end
      end
      # xml.__send__(:answer_options) do
      #   self.codes.map { |code| code.item_choice }.uniq.each do |item_choice|
      #     xml.answer_option item_choice.name
      #     xml.datatype item_choice.datatype
      #     xml.no_options item_choice.no_options
      #     # item_choice.item_options.each do |option|
      #     #   xml
      #   end
      # end
    end
  end
end
