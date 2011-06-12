require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'

class AnswerCell < ActiveRecord::Base
	def self.answer_types
    {"Rating" => 0, "Checkbox" => 1, "ListItemComment" => 2, "SelectOption" => 3, "TextBox" => 4, "ListItem" => 5}
  end
	
  belongs_to :answer
  belongs_to :variable
  set_primary_key "id"
	attr_accessor :position
  
	# named_scope :ratings, :conditions => ['answertype = ?', 'Rating']
  named_scope :ratings, :conditions => ['cell_type = ?', AnswerCell.answer_types['Rating']]
  named_scope :not_answered, :conditions => ["(value = ? OR value = NULL)", '9']
  named_scope :items, :conditions => ["item != ? ", ""]
  
  attr_accessor :variable_name

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
	
	def cell_value
		self.value_text || self.value
	end
	
	def html_value_id(fast = false)
		# if self.cell_type == AnswerCell.answer_type["Checkbox"]
		# 	"q#{answer.number}_#{row}_#{col}"			
		if rating
			# puts "HTML_VALUE position #{position}"
			"q#{answer.number}_#{row}_#{col}_#{position}"
		else
			"q#{answer.number}_#{row}_#{col}"
		end
	end
	
	def javascript_set_value(fast = false)
		return "" if fast && value == 9 || value.blank?
		result = if rating || self.answer_type == "Checkbox"
			"$('#{html_value_id(fast)}').checked = #{value != 9};"
		else
			"$('#{html_value_id(fast)}').value = #{value};"
		end
		puts "JAVASCRIPT_SET_VALUE: #{result}"
		result
	end
  # 
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