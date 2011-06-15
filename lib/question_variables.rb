module QuestionVariables
  # set variables from existing var, otherwise create var name
  # def set_variables
  #   prefix = survey.prefix
  # 
  #   q = self.number.to_roman.downcase
  #   self.question_cells.map do |cell|
  #     if cell.class.to_s =~ /Rating|Checkbox|ListItemComment|SelectOption|TextBox/
  #       var = Variable.get_by_question(id, cell.row, cell.col)
  #       if var
  #         # puts "Setting cell (#{cell.row},#{cell.col}) i: #{cell.answer_item}: #{var.var}"
  #         cell.var = var.var
  #       else
  #         item = cell.answer_item
  #         item << "hv" if !(item =~ /hv$/) && cell.type =~ /Comment|Text/
  #         cell.var = "#{prefix}#{q}#{item}"
  #       end
  #     else
  #       cell.var = "" unless cell.var.nil?
  #     end
  #     cell.save
  #       cell
  #   end
  # end

  # creates default variables   
  # def get_variables(prefix = nil)
  #   cells = Dictionary.new
  #   prefix ||= survey.prefix
  # 
  #   q = self.number.to_roman.downcase
  #   # puts "answerable cells for q: #{self.id} n: #{self.number} :: #{self.question_cells.answerable.count}"
  #   self.question_cells.answerable.map do |cell|
  #     # if cell.class.to_s =~ /Rating|Checkbox|ListItemComment|SelectOption|TextBox/
  #       var = Variable.get_by_question(id, cell.row, cell.col)
  #       if var
  #           var.item = cell.answer_item
  #           var.value = cell.value || "#NULL!"
  #           var.datatype = cell.datatype.to_s
  #         cells[var.var.to_sym] = var
  #       else  # default var name
  #         item = cell.answer_item
  #           var = Variable.new({:row => cell.row, :col => cell.col, 
  #             :question_id => cell.question_id, :survey_id => survey.id, 
  #             :item => cell.answer_item, :datatype => cell.datatype.to_s})
  #           item << "hv" if !(item =~ /hv$/) && cell.type =~ /Comment|Text/
  #           var.var = "#{prefix}#{q}#{item}"
  #           var.value = cell.value.blank? && "#NULL" || cell.value
  #         cells[var.var.to_sym] = var
  #       end
  #     # end
  #   end
  #   return cells
  # end
  
  # def test_variables(prefix = nil)
  #   cells = Dictionary.new
  #   prefix ||= survey.prefix
  # 
  #   q = self.number.to_roman.downcase
  #   # puts "answerable cells for q: #{self.id} n: #{self.number} :: #{self.question_cells.answerable.count}"
  #   self.question_cells.map do |cell|
  #     if cell.class.to_s =~ /Rating|Checkbox|ListItemComment|ListItem|SelectOption|TextBox/
  #       var = Variable.get_by_question(id, cell.row, cell.col)
  #       if var
  #         cells[var.var.to_sym] = var.var + ":" + (cell.value || "#NULL!")
  #       else  # default var name
  #         item = cell.answer_item
  #         item << "hv" if !(item =~ /hv$/) && cell.type =~ /Comment|Text/
  #         cells["#{prefix}#{q}#{item}".to_sym] = cell.value.blank? && "#{prefix}#{q}#{item}:" + ("#NULL!" || cell.value) # !! default value is "", not nil
  #       end
  #     end
  #   end
  #   return cells
  # end
  
end