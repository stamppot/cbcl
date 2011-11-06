DEBUG = false

class FillCodeBooks

  # def get_text_and_rating_cell_for_row(question_id, row)
  #   q_cells = QuestionCell.find_all_by_question_id_and_row(question_id, row)
  #   text_cells, rating_cells = q_cells.partition {|c| c.question_items.first.text.size > 1}
  #   if rating_cells.any?
  #     rating_cells = rating_cells.reject { |cell| cell.question_items.first.text.blank? }
  #     rating_cell = rating_cells.first 
  #   end
  #   text_cell = text_cells.first if text_cells.any?
  #   [rating_cell, text_cell]
  # end


  def create_codebooks
    survey_ids = Survey.all.inject({}) {|h, s| h[s.id] = s; h }
    codebooks = CodeBook.all.inject({}) {|h, cd| h[cd.survey_id] = cd; h }
    Variable.all.each do |v|
      survey = survey_ids[v.survey_id]
      codebook = codebooks[v.survey_id]
      if !(codebook = CodeBook.find_by_survey_id(survey.id))
        codebook = CodeBook.find_by_survey_id(survey.id)
        CodeBook.create(:survey_id => survey.id, :title => survey.title,
        :description => survey.description)
      end

      next if codebook.codes.find_by_variable(v.var)
      # puts "rating_cell: #{rating_cell.inspect}  text_cell: #{text_cell.inspect}" if v.item.nil? && DEBUG

      item_choice = get_item_choice(v)
      item_type = get_item_type(v)
      description = get_item_description(v)

      code = Code.create(
      :code_book_id => codebook.id,
      :question_id => v.question_id,
      :question_number => v.question.number,
      :item_type => item_type,
      :variable => v.var,
      :datatype => v.datatype,
      :item => v.item || (v.col == 1 && "#{v.question_cell.answer_item}_none" || v.question_cell.answer_item),
      :description => description,
      :measurement_level => "Nominal",
      :row => v.row,
      :col => v.col,
      :item_choice_id => item_choice.id
      )
      puts "Code: #{code.inspect}" if DEBUG
    end
  end

  def get_description_cell(variable)
    description_cell = nil
    # try to find rating descriptions in same row
    row_cells = variable.question.question_cells.find_all_by_row(variable.row)
    description_cells = row_cells.select {|cell| cell.question_items.any? {|item| item.text.size > 1}}
    if description_cells.any?
      description_cell = description_cells.first
    else  # then in top of question
      descriptions = variable.question.question_cells.select {|qc| qc[:type] == "Description"}
      if descriptions.any?
        description_cell = descriptions.first
      else
        descriptions = question.question_cells.select {|qc| qc[:type] == "Information"}
        description_cell = descriptions.last if descriptions.any?
      end    
    end
    description_cell
  end

  def get_item(variable)
    if variable.item.nil?
      cell = variable.question_cell
      row_vars = Variable.find_all_by_question_id_and_row(variable.question_id, variable.row)
      other_row_var = row_vars.select {|var| var.item}.first
      item = "#{other_row_var.var}_#{get_item_suffix(other_row_var.question_cell)}"
    else
      variable.col == 1 && "#{variable.question_cell.answer_item}_none" || variable.question_cell.answer_item
    end
  end

  def get_item_choice(variable)
    description_cell = get_description_cell(variable)
    item_choice = create_item_choice(description_cell, variable)
  end

  def get_item_type(variable)
    question_cell = variable.question_cell
    item_type = variable.item && question_cell.type
    item_type = "ListItemComment" if question_cell.answer_item =~ /hv$/
    item_type ||= (variable.col == 1 && variable.item.nil?) && "Checkbox" || "ListItemComment"
    item_type ||= "Rating"
    puts "ItemType: #{item_type} cell: #{question_cell && question_cell.answer_item || 'nil' } for #{variable}" if DEBUG
    item_type
  end

  def get_item_description(variable)
    description_cell = get_description_cell(variable)
    description = description_cell.question_items.first.text
  end

  def get_missing_item(question_cell)
    case question_cell[:type]
    when "SelectOption" : "option"
    when "Checkbox" : "#{question_cell.question.survey.prefix}#{question_cell.question.number}none"
    else question_cell[:type]
    end
  end

  def create_item_choice(description_cell, variable)
    default_item_choice = ItemChoice.find_by_name("Rating3_0_2")
    word_counts = get_item_choice_number(description_cell)
    items = description_cell.question_items
    type = description_cell[:type]

    get_default_item_choice(description_cell, variable, word_counts, items) ||
    get_generated_item_choice(description_cell, variable, word_counts, items)
    # if variable.question_id == variable.question.survey.max_question.id || 
    #   (type == "Rating" && (word_counts == "284" || word_counts == "111") && items.size == 3)
    #   default_item_choice
    # item_choice || begin
    # name = type =~ /Description|Information/ && "Rating" || type
    # name = "#{name}#{items.size}_#{word_counts}_#{items.first.value}_#{items.last.value}"
    # datatype = variable.datatype
    # params = {:name => name, :datatype => datatype, :no_options => items.size}
    # item_choice = ItemChoice.find_by_name(name) || ItemChoice.create(params)
    # 
    # items.each_with_index do |item,i|
    #   item_choice.item_options.find_by_code(item.value.to_i) ||
    #   item_choice.item_options.create(:item_choice => item_choice,
    #                                   :option => "option #{i+1}", 
    #                                   :code => item.value.to_i,
    #                                   :label => item.text)
    # end
    # item_choice
    # end
  end


  def get_default_item_choice(cell, variable, word_counts, items)
    default_item_choice = ItemChoice.find_by_name("Rating3_0_2")
    default_item_choice = if variable.question_id == variable.question.survey.max_question.id || 
      (cell[:type] == "Rating" && (word_counts == "284" || word_counts == "111") && items.size == 3)
    else
      nil
    end
  end

  def get_generated_item_choice(cell, variable, word_counts, items)
    name = cell[:type] =~ /Description|Information/ && "Rating" || cell[:type]
    name = "#{name}#{items.size}_#{word_counts}_#{items.first.value}_#{items.last.value}"
    datatype = variable.datatype
    params = {:name => name, :datatype => datatype, :no_options => items.size}
    item_choice = ItemChoice.find_by_name(name) || ItemChoice.create(params)

    items.each_with_index do |item,i|
      item_choice.item_options.find_by_code(item.value.to_i) ||
      item_choice.item_options.create(:item_choice => item_choice,
      :option => "option #{i+1}", 
      :code => item.value.to_i,
      :label => item.text)
    end
    item_choice
  end

  def get_item_choice_number(question_cell)
    item_type = question_cell[:type]
    item_texts = question_cell.question_items.map(&:text)
    if item_type == "Information"
      skip_list = %w{0 1 2}
      texts = item_texts.map {|text| text.split}.first
      texts = texts.reject {|t| skip_list.include? t}.join(' ')
      item_texts = texts.split('=').map(&:strip).reject {|i| i.empty?}
      # puts "#{question_cell[:type]}: #{item_texts.inspect} #{item_texts.map {|t| t.split.size}.join}" if DEBUG
    end
    item_texts.map {|text| text.split.size}.join
  end

  def create_answer_options
    itemChoice = ItemChoice.create(:name => "Rating3_0_2",
    :datatype => "numeric",
    :no_options => 3)

    itemChoice.item_options.create(:item_choice => itemChoice,
    :option => "option 1",
    :code => 0,
    :label => "Passer ikke")
    itemChoice.item_options.create(:item_choice => itemChoice,
    :option => "option 2",
    :code => 1,
    :label => "Passer til en vis grad eller nogen gange")
    itemChoice.item_options.create(:item_choice => itemChoice,
    :option => "option 3",
    :code => 2,
    :label => "Passer godt eller ofte")
    itemChoice
  end

  # create_answer_options

  def do!
    ItemOption.destroy_all
    ItemChoice.destroy_all
    Code.destroy_all
    CodeBook.destroy_all
    create_answer_options
    create_codebooks
  end

end