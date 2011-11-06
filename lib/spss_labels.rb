class SpssLabels
  
  attr_accessor :item_choices
  
  # def initialize(item_choices)
  #   self.item_choices
  # end
  
  def variable_labels(codebook)
    labels = ["VARIABLE LABELS"]
    codebook.codes.each do |code|
      labels << "  #{code.variable} \"#{code.description}\""
    end
    labels
  end

  def value_labels(codebook)
    labels = ["VALUE LABELS"]
    codebook.codes.each do |code|
      item_options = code.item_choice.item_options
      value_label = "  #{code.variable}"
      item_options.each do |option|
        value_label << " #{option.code} \"#{option.label}\""
      end
      labels << value_label
    end
    labels
  end
end