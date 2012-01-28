require 'facets/dictionary'
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'
class Answer < ActiveRecord::Base
  belongs_to :survey_answer
  belongs_to :question
  # has_many :test_cells
  has_many :answer_cells, :dependent => :delete_all, :order => 'row, col ASC'  # order by row, col
  has_many :variables
  validates_presence_of :question_id, :survey_answer_id

  # before_save :update_ratings_count
  
  def update_ratings_count
		answer_ratings_count = self.ratings.count # subtract values of 9
		answer_ratings_count -= self.ratings.select { |ac| ac.value == 9}.size
    self.ratings_count = self.question.ratings_count - answer_ratings_count
  end

  def answer_cell_exists?(col, row)
    self.answer_cells(true).find(:first, :conditions => ['row = ? AND col = ?', row, col] )
  end

  def to_csv(prefix = nil)
    cells = Dictionary.new
    prefix = survey_answer.survey.prefix unless prefix
    q = self.question.number.to_roman.downcase
    
    self.answer_cells.each_with_index do |cell, i|
      value = cell.value.blank? && '#NULL!' || cell.value
      if var = Variable.get_by_question(self.question_id, cell.row, cell.col)
        cells[var.var.to_sym] = value
      else  # default var name
        answer_type = cell.answer_type
				item = cell.item || ""
        # item = "" if cell.item.blank?
        # answer_type, item = self.question.get_answertype(cell.row, cell.col)
        item << "hv" if (item.nil? or !(item =~ /hv$/)) && cell.text?
        # item << "hv" if (item.nil? or !(item =~ /hv$/)) && answer_type =~ /Comment|Text/
        var = "#{prefix}#{q}#{item}".to_sym
        cells[var] = 
        if cell.text? && !cell.value_text.blank? #answer_type =~ /ListItem|Comment|Text/ && !cell.value.blank?
          CGI.unescape(cell.value_text).gsub(/\r\n?/, ' ').strip
        # if answer_type =~ /ListItem|Comment|Text/ && !cell.value.blank?
#          CGI.unescape(cell.value).gsub(/\r\n?/, ' ').strip
        else
          value
        end
      end
    end
    return cells
  end

  alias :cell_values :to_csv

	# TODO: rewrite assuming all variables exists (no if statement), create new variable or set variable values (datatype)
  def get_variables(prefix = nil)
    cells = Dictionary.new
    prefix ||= self.survey_answer.survey.prefix
    q = self.number.to_roman.downcase
    # cells[:number] = self.question.number

    # puts "answerable cells for q: #{self.id} n: #{self.number} :: #{self.question_cells.answerable.count}"
		self.answer_cells.map do |cell|
			var = Variable.get_by_question(id, cell.row, cell.col)
			if var
				var.value = cell.value || "#NULL!"
				var.datatype = cell.datatype
				cells[var.var.to_sym] = var
			else  # default var name
				item = cell.item
				var = Variable.new({:row => cell.row, :col => cell.col, 
					:question_id => self.question.id, :survey_id => self.question.survey_id, 
					:item => cell.item, :datatype => cell.datatype})
					item << "hv" if !(item =~ /hv$/) && cell.class.to_s =~ /Comment|Text/
					var.var = "#{prefix}#{q}#{item}"
					var.value = cell.value.blank? && "#NULL" || cell.value
					cells[var.var.to_sym] = var
				end
			end
    return cells
  end

  # def cell_vals(prefix = nil)
  #   answer = Dictionary.new
  #   prefix = survey_answer.survey.prefix unless prefix
  #   q = self.question.number.to_roman.downcase
  #   answer[:number] = self.question.number
  #   cells = []
  #   
  #   self.answer_cells.each_with_index do |cell, i|
  #     c = {}
  #     type = :Integer
  #     # value = cell.value.blank? && '#NULL!' || cell.value
  #     if var = Variable.get_by_question(self.question_id, cell.row, cell.col) # variable exists
  #       c[:var] = var.var.to_sym
  #     else  # default var name
  #       answer_type = cell.answer_type
  #       item = cell.item || ""
  #       # answer_type, item = self.question.get_answertype(cell.row, cell.col)
  #       if (item.nil? or !(item =~ /hv$/)) && answer_type =~ /Comment|Text/
  #         item << "hv" 
  #         type = :String
  #       end
  #       var = "#{prefix}#{q}#{item}".to_sym
  #       c[:var] = var
  #       # cs[var] = 
  #       # if answer_type =~ /ListItem|Comment|Text/ && !cell.value.blank?
  #       #   type = "String"
  #       #   cell.value = CGI.unescape(cell.value).gsub(/\r\n?/, ' ').strip
  #       if cell.text? || !cell.cell_value.blank?
  #         type = :String
  #         cell.value_text = CGI.unescape(cell.value_text || "").gsub(/\r\n?/, ' ').strip
  #       end
  #       # value = cell.value.to_i if type == :Integer && !cell.value.blank?
  #       value = cell.value.to_i if !cell.text? && !cell.value.blank?
  #       c[:type] = type
  #       c[:v] = value
  #       # puts c.inspect
  #       cells << c
  #     end
  #   end
  #   answer[:cells] = cells
  #   return answer
  # end
  

  # returns array of cells. Sets answertype
  def create_cells_optimized(cells = {}, valid_values = {})
    new_cells = []
		types = AnswerCell.answer_types
    cells.each do |cell_id, fields|  # hash is {item=>x, value=>y, qtype=>z, col=>a, row=>b}
      value = fields[:value]
      next if value.blank? # skip blanks
      fields[:answer_id] = self.id
      # fields[:answertype] = valid_values[cell_id][:type]  # not necessarily needed
			fields[:cell_type] = AnswerCell.answer_types[valid_values[cell_id][:type]]
			# 09-10-2010
			fields[:rating] = valid_values[cell_id][:type] == "Rating"  # set boolean
      fields[:item] = valid_values[cell_id][:item]        # save item, used to calculate score
      
      if valid_values[cell_id][:type] =~ /Rating|SelectOption/       # validates value for rating and selectoption
        # only save valid values, do not save empty answer cells
         next if !valid_values[cell_id][:values].include?(value) # skip invalid ratings & selectoptions
        # value = "" if value.blank?     # only save 9 as unanswered for rating and selectoption
        fields[:value] = value if valid_values[cell_id][:values].include? value # only save valid value
				fields[:text] = false
			elsif valid_values[cell_id][:type] == "Checkbox"
				fields[:value] = value
				fields[:text] = false
      else
        fields[:value_text] = CGI.escape(value.gsub(/\r\n?/,' ').strip) # DONE: escaping of text (done right!)
        fields[:value] = nil
				fields[:text] = true
      end
			# TODO: writes value to both columns. Later, fix it so only text values are written to value_text
      # fields[:value_text] = fields[:value]
			fields[:cell_type] = types[valid_values[cell_id][:type]]
      new_cells << [fields[:answer_id], fields[:row], fields[:col], fields[:item], fields[:value], fields[:rating], fields[:text], fields[:value_text], fields[:cell_type]]
    end
    return new_cells
  end

  def fill_unanswered_cells(survey_answer)
    add_missing_cells(survey_answer.max_answer)
  end
    
  def ratings
    self.answer_cells.ratings
  end

  # only valid for long questions/answers with a matching score_item 
  def not_answered_ratings
    self.ratings.not_answered.count
  end
    
  def count_items
    # AnswerCell.count(:conditions => ["answer_id = ? AND item != ? ", self.id, "" ])
    self.answer_cells.items.size
  end

  def exists?(row, col)
    @cells ||= rows_of_cols
    @cells[row][col] if @cells[row] && @cells[row][col]
  end
  
  # should do exactly the same as hash_rows_of_cols, and is faster too!
  def rows_of_cols
    result = self.answer_cells.inject({}) do |rows, cell|
      rows[cell.row] = {} unless rows[cell.row]
      rows[cell.row][cell.col] = cell
      rows
    end
  end
  
  # comparison based on row number
  def <=>(other)
    self.question <=> other.question
  end

	def setup_draft_values
		q_cells = self.question.rows_of_cols
		a_cells = self.rows_of_cols
		a_cells.each_pair do |row, cols|           # go thru a_cells to make it faster
			cols.each_pair do |col, cell|
				if !cell.value.blank?
					position_values = q_cells[row][col].value_to_text
          # puts "q_cell.value_to_text #{q_cells[row][col].value_to_text.inspect}"
          # puts "looking for position for value: #{cell.cell_value} or #{cell.value}"
					if cell.value != 9 && result = position_values.assoc(cell.cell_value.to_s)
					  pos = result.last
            cell.position = pos unless pos.nil?
						puts "ERRRORR value cell pos nil: #{cell.inspect}" if pos.nil?
					end
				elsif cell.value_text
				  position_values = q_cells[row][col].value_to_text
					if result = position_values.assoc(cell.cell_value.to_s)
						pos = result.last
						cell.position = pos unless pos.nil?
						puts "ERRRORR value_text cell pos nil: #{cell.inspect}" if pos.nil?
					end
				end  
			end
		end
		all_answer_cells = []
		a_cells.each_path { |path, value| all_answer_cells << value }
    # puts "all size: #{all_answer_cells.size}"
		all_answer_cells
	end
  
  def print
    output = "Answer: #{self.number}<br>"
    answer_cells.sort_by {|cell| cell.item.to_i }.each { |cell| output << "#{cell.item} => #{cell.value}<br>" }
    return output
  end
  
  def to_xml
    xml = []
    xml << "<answer question='#{self.number.to_s}' question_id='#{self.question_id.to_s}' >"
    xml << "  <answer_cells>"
    if self == self.parent_max_answer
      self.parent.cell_values.each do |var, val|
        "<v >"
      end
    else
      xml << self.answer_cells.collect { |answer_cell| answer_cell.to_xml }
    end
    xml << "  </answer_cells>"
    xml << "</answer>"
  end
  
  def set_missing_items
    q_cells = cache_fetch("question_cells_#{self.question_id}") { self.question.rows_of_cols }
    counter = 0
    a_cells = self.answer_cells.find(:all, :conditions => ['item IS NULL'])
    a_cells.each do |a_cell|
      q_cell = q_cells[a_cell.row][a_cell.col]
      if q_cell && q_cell.answer_item
        a_cell.item = q_cell.answer_item
        a_cell.answer_type = q_cell.type unless a_cell.answer_type
        a_cell.save
        a_cell = nil
        counter += 1
        # puts "set another 100 a_cells" if counter % 100 == 0
      end
    end
    a_cells.clear
    a_cells = nil
  end
  
  def self.set_missing_items
    self.find_in_batches { |answers| answers.each { |answer| answer.set_missing_items } }
  end
end
