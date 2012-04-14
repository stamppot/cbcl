QuestionCell.all.each do |cell|
  is_input = false
  is_reportable = false
  props = []
  
  if cell.is_a?(Rating) || cell.is_a?(ListItemComment) || cell.is_a?(SelectOption) || cell.is_a?(TextBox) || cell.is_a?(Checkbox) ||
    (cell.is_a?(ListItem) && cell.question_items.any? {|item| item.text.blank?})
    is_input = true
    props << "input" if is_input
    puts "is_input: #{cell.inspect}, props: #{props.inspect}"
  end
  
  if is_input
    puts "input: #{cell.row},#{cell.col}:#{cell.class}"
  end
  
  if cell.is_a?(ListItemComment)
    is_reportable = true
  end
  props << "report" if is_reportable
  
  cell.properties = props #unless props.empty?
  cell.save
end

