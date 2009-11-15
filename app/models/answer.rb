require 'facets/dictionary'

class Answer < ActiveRecord::Base
  belongs_to :survey_answer
  has_many :answer_cells, :dependent => :delete_all, :order => 'row, col ASC'  # order by row, col
  belongs_to :question
  
  # TODO: test. added 14-6
  validates_presence_of :question_id, :survey_answer_id

  def to_csv(prefix)
    cells = Dictionary.new
    prefix = survey_answer.survey.prefix unless prefix
    # survey_id = survey_answer.survey_id
    q = self.question.number.to_roman.downcase
    
    self.answer_cells.each_with_index do |cell, i|
      value = cell.value.blank? && '#NULL!' || cell.value
      if var = Variable.get_by_question(self.question_id, cell.row, cell.col)
        cells[var.var.to_sym] = value
        # puts "VAR found: #{var} cell: #{cell.inspect}" if [:ccyi, :ccyi1a, :ccyi1b, :ccyi1c, :ccyii, :ccyii1a, :ccyii1b, :ccyii1c, :ccyiii, :ccyiii1a, :ccyiii1b].include?(var)
      else  # default var name
        item = cell.item.to_s
        if (item.nil? or !(item =~ /hv$/)) && cell.answertype =~ /Comment|Text/
          item << "hv" 
        end
        # if "#{prefix}#{q}#{item}" =~ /^ccy$|^ccy1f$|^ccy1g$|^ccy3hv$|^ycy$|^ycy1f$|^ycy1g$/
        var = "#{prefix}#{q}#{item}".to_sym

        cells[var] = 
        if cell.answertype =~ /ListItem|Comment|Text/ && !cell.value.blank?
          CGI.unescape(cell.value).gsub(/\r\n?/, ' ').strip
        else
          value
        end
      end
    end
    return cells
  end

  alias :cell_values :to_csv

  # def nested_cell_values
  #   cells = Dictionary.new
  #   self.answer_cells.map do |cell|
  #     cells[cell.row] = {cell.col => cell.value }
  #   end
  #   return cells
  # end
  

  # input: hash with cell values
  def create_cells(cells = {}, valid_values = {})
    cells.each do |cell_id, fields|  # hash is {item=>x, value=>y, qtype=>z, col=>a, row=>b}
      fields[:answer_id] = self.id
      fields[:answertype] = valid_values[cell_id][:type].to_s

      value = fields[:value]
      # validates value for rating and selectoption
      if valid_values[:type] =~ /Rating|SelectOption/
        value = "9" if value.blank?     # only save 9 as unanswered for rating and selectoption
        fields[:value] = value if valid_values[:fields].include? value # only save valid value
        # end
      else
        fields[:value] = CGI.escape(value.gsub(/\r\n?/,' ').strip)  # TODO: escaping of text (dangerous here!)
      end
      a_c = AnswerCell.create(fields)
    end
    return self
  end
    
  # returns answer cells which are ratings
  def ratings
    self.answer_cells.ratings
  end

  def not_answered_ratings
    self.answer_cells.ratings.count(:conditions => ['value = ? OR value = NULL', '9'])
  end
    
  def count_items
    # AnswerCell.count(:conditions => ["answer_id = ? AND item != ? ", self.id, "" ])
    self.answer_cells.items
  end

  # should do exactly the same as hash_rows_of_cols, and is faster too!
  def rows_of_cols
    result = self.answer_cells.inject({}) do |rows, cell|
      rows[cell.row] = {} unless rows[cell.row]
      rows[cell.row][cell.col] = cell
      rows
    end # .build_hash { |cell| [cell.row, {cell.col => cell}] }
  end
  
  # comparison based on row number
  def <=>(other)
    self.question <=> other.question
  end
  
  # def test_saved(answer)
  #   if (self.id == answer.id) and (self.question_id == answer.question_id) and (self.number == answer.number)
  #     check_cells = answer_cells.zip answer.answer_cells#(true)
  #     check_cells.each { |tuple| tuple.first.equal(tuple.last) }
  #   else
  #     raise RuntimeError("Answer.test_saved: Saved value is not right!")
  #   end
  # end
  
  def answer_cell_exists?(col, row)
    # TODO: :select => id, row, col, value
    a_cell = self.answer_cells(true).find(:first, :conditions => ['row = ? AND col = ?', row, col])
    return a_cell
  end
  
  def print
    output = "Answer: #{self.number}<br>"
    answer_cells.sort_by {|cell| cell.item.to_i }.each { |cell| output << "i: #{cell.item} => #{cell.value}<br>" }
    return output
  end
  
  def to_xml
    xml = []
    xml << "<answer question='#{self.number.to_s}' question_id='#{self.question_id.to_s}' >"
    xml << "  <answer_cells>"
    xml << self.answer_cells.collect { |answer_cell| answer_cell.to_xml }
    xml << "  </answer_cells>"
    xml << "</answer>"
  end
  
end
