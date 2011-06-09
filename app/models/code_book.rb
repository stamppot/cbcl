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
end
