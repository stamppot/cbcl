require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'
# require 'erb' # 

class AnswerCell < ActiveRecord::Base
	def self.answer_types
    {"Rating" => 0, "Checkbox" => 1, "ListItemComment" => 2, "SelectOption" => 3, "TextBox" => 4, "ListItem" => 5}
  end
	
  belongs_to :answer
  set_primary_key "id"
  named_scope :ratings, :conditions => ['cell_type = ?', AnswerCell.answer_types['Rating']]
  named_scope :not_answered, :conditions => ["(value = ? OR value = NULL)", '9']
  named_scope :items, :conditions => ["item != ? ", ""]
  
  attr_accessor :variable_name
  attr_accessor :position

  def change_value(new_value, valid_values = {})
    new_value = new_value || ""
    if self.rating? || valid_values[:type].to_s == "SelectOption"   # if not valid, keep existing value
      new_value = "9" if new_value.blank?
      if new_value != self.value && valid_values[:values].include?(new_value)
        self.value = new_value
      end
    else  # other types
      self.value_text = CGI.escape(new_value) if new_value != self.value_text  # TODO: escape value
    end
    return changed?
  end
  
  def change_value!(new_value, valid_values = {})
    self.save if change_value(new_value, valid_values)
  end
  
	def datatype
		cell_type < 2 && :numeric || :string
	end
	
  # comparison based on row first, then column
  def <=>(other)
    if self.row == other.row
      self.col <=> other.col
    else
      self.row <=> other.row
    end
  end

  def equal(cell)
  return (id = cell.id) && (answer_id == cell.answer_id) && (col == cell.col) && (row == cell.row) &&
    (item = cell.item) && (value = cell.value)
  end
	
	def answer_type=(a_type)  
	  self.cell_type = AnswerCell.answer_types[a_type]  
	end  

	def answer_type  
	  AnswerCell.answer_types.index(self.cell_type)
	end
	
	def text?
		self.text
	end
	
	def rating?
		self.rating
	end
	
	def checkbox?
	  self.cell_type == AnswerCell.answer_types["Checkbox"] 
  end
  
  def select?
    self.cell_type == AnswerCell.answer_types["SelectOption"] 
  end

	def cell_value
		self.value_text || self.value
	end

  def input_type
    if rating?
      "radio"
    elsif checkbox?
      "checkbox"
    elsif select?
      "select"
    else
      "text"
    end
  end

  def html_value_id(fast = false)
    if rating
      puts "ERRRRROOOORRRRR: HTML_VALUE position #{position}: q#{answer.number}_#{row}_#{col}" unless position
      # return "" unless position
      position && "q#{answer.number}_#{row}_#{col}_#{position-1}" || "q#{answer.number}_#{row}_#{col}"
    elsif rating && position.nil? # rating with unchosen value
    elsif self.text
      # puts "TExt cell (#{self.answer_type}): q#{answer.number}_#{row}_#{col} - value: #{self.value_text}"
      "q#{answer.number}_#{row}_#{col}"
    else
      # puts "SmtH else than TEXt or RATing: #{self.answer_type}  value: #{self.value} or #{self.value_text}"
      "q#{answer.number}_#{row}_#{col}"
    end
  end
	
  def input_name(fast = false)
    if rating
      puts "ERRRRROOOORRRRR: HTML_VALUE position #{position}: q#{answer.number}_#{row}_#{col}" unless position
      # return "" unless position
      "Q#{answer.number}[q#{answer.number}_#{row}_#{col}]"
    # elsif rating && position.nil? # rating with unchosen value
    elsif self.text
      # puts "TExt cell (#{self.answer_type}): q#{answer.number}_#{row}_#{col} - value: #{self.value_text}"
      "q#{answer.number}_#{row}_#{col}"
    else
      # puts "SmtH else than TEXt or RATing: #{self.answer_type}  value: #{self.value} or #{self.value_text}"
      "q#{answer.number}_#{row}_#{col}"
    end
  end

  def get_draft_value
    { :elem => input_name, :value => javascript_get_value, :input => input_type }
  end

  def javascript_get_value(fast = false)
    # return "" if fast && value == 9 || (!self.text && (value.blank? || value == 9))
    result = if rating
      # puts "RatingSET JS VAL #{self.answer_type}: " + "$('#{html_value_id(fast)}').checked = #{self.value != 9};"
      value != 9 && value || "" 
    elsif self.checkbox?
      self.value
    elsif self.text
      # puts "TextSET JS VAL #{self.answer_type}: " +       "$('#{html_value_id(fast)}').value = '#{self.value_text}';"
      # "$('#{html_id}').value = " + CGI::unescape("\"#{self.value_text}\";")
      javascript_escape_text(self.value_text)
    else
      if self.value_text
        javascript_escape_text(self.value_text)
      else
        javascript_escape_text(self.value)
      end
      self.value
    end
    result
  end

	def javascript_set_value(fast = false)
		return if fast && value == 9 || (!self.text && (value.blank? || value == 9))
		html_id = html_value_id(fast)
		result = if rating
      # puts "RatingSET JS VAL #{self.answer_type}: " + "$('#{html_value_id(fast)}').checked = #{self.value != 9};"
			"$('#{html_id}').checked = #{value != 9};" 
		elsif self.checkbox?
		  "$('#{html_id}').checked = #{self.value};"
    elsif self.text
      # puts "TextSET JS VAL #{self.answer_type}: " +       "$('#{html_value_id(fast)}').value = '#{self.value_text}';"
      # "$('#{html_id}').value = " + CGI::unescape("\"#{self.value_text}\";")
			"$('#{html_id}').value = " + javascript_escape_text(self.value_text)
		else
		  if self.value_text
  			"$('#{html_id}').value = " + javascript_escape_text(self.value_text)
		  else
  			"$('#{html_id}').value = " + javascript_escape_text(self.value)
	    end
			"$('#{html_id}').value = #{self.value};"
		end
    if html_value_id(fast).blank?
	    puts "SOMETHINGS WRONG: #{self.inspect} html_value: #{html_id.inspect}  q#{answer.number}_#{row}_#{col} value: #{value} value_text: #{value_text}"
	    return
    end
		result
	end
	
	def javascript_escape_text(text)
    unescaped = CGI::unescape("#{text}")
    # puts "javascript_escape_text: #{escape_javascript(unescaped).inspect}"
    # do_replace = unescaped.include? "\n"
    # if do_replace
    #   puts "do gsub: #{unescaped.inspect}"
    unescaped = unescaped.gsub("\n", '%0A') # if unescaped.include? '\n'
      # puts "done: #{unescaped.inspect}"
    # end
	  "unescape('" + escape_javascript(unescaped) + "'); "
  end

  # def to_xml
  #   r = []
  #   
  # def to_xml
  #   t.column :answertype, :string, :limit => 20
  #   t.column :col, :int, :null => false
  #   t.column :row, :int, :null => false
  #   t.column :item, :string, :limit => 5
  #   t.column :value, :string
  #   xml = []
  #   xml << "<answer_cell answer_type='#{self.answertype}' col='#{self.col.to_s}' row='#{self.row.to_s}'>"
  #   xml << "  <item>#{self.item}</item>"
  #   xml << "  <value>#{self.value}</value>"
  #   xml << "</answer_cell>"
  # end
end

# class RatingAnswer < AnswerCell
# end
# 
# class SelectOptionAnswer < AnswerCell
# end
# 
# class CheckboxAnswer < AnswerCell
# end