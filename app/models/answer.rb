# require 'facets/dictionary'
class Answer < ActiveRecord::Base
  belongs_to :survey_answer
  has_many :answer_cells, :dependent => :delete_all, :order => 'row, col ASC'  # order by row, col
  belongs_to :question
  
  # TODO: test. added 14-6
  validates_presence_of :question_id, :survey_answer_id

  before_save :update_ratings_count
  
  def update_ratings_count
    self.ratings_count = self.answer_cells.ratings.not_answered.count unless self.answer_cells.empty?
  end

  def to_csv(prefix)
    cells = Dictionary.new
    prefix = survey_answer.survey.prefix unless prefix
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

  def create_cells(cells = {}, valid_values = {})
    cells.each do |cell_id, fields|  # hash is {item=>x, value=>y, qtype=>z, col=>a, row=>b}
      fields[:answer_id] = self.id
      fields[:answertype] = valid_values[cell_id][:type].to_s

      value = fields[:value]
      # validates value for rating and selectoption
      if valid_values[:type] =~ /Rating|SelectOption/
        value = "" if value.blank?     # only save 9 as unanswered for rating and selectoption
        fields[:value] = value if valid_values[:fields].include? value # only save valid value
        # end
      else
        fields[:value] = CGI.escape(value.gsub(/\r\n?/,' ').strip)  # TODO: escaping of text (dangerous here!)
      end
      a_c = AnswerCell.create(fields)
    end
    return self
  end

  # returns array of cells. Sets answertype
  def create_cells_optimized(answer_id, cells = {}, valid_values = {})
    new_cells = []
    cells.each do |cell_id, fields|  # hash is {item=>x, value=>y, qtype=>z, col=>a, row=>b}
      value = fields[:value]
      next if value.blank? # skip blanks
      fields[:answer_id] = self.id
      puts "cell_id: #{cell_id}"
      # puts "create_cells_opti, cell: #{cell_id}, valid_values: #{valid_values.inspect}"
      fields[:answertype] = valid_values[cell_id][:type]  # TODO: is answertype needed to save??

      # validates value for rating and selectoption
      if valid_values[cell_id][:type] =~ /Rating|SelectOption/
        # only save valid values, do not save empty answer cells
        puts "valid_values: #{valid_values[cell_id][:values].inspect}  value: #{value}"
         next if !valid_values[cell_id][:values].include?(value) # skip invalid ratings & selectoptions
        # value = "" if value.blank?     # only save 9 as unanswered for rating and selectoption
        fields[:value] = value if valid_values[cell_id][:values].include? value # only save valid value
      else
        fields[:value] = CGI.escape(value.gsub(/\r\n?/,' ').strip)  # TODO: escaping of text (dangerous here!)
      end
      # new_cells << AnswerCell.new(fields)
      puts "new_cells << fields: #{fields.inspect}"
      new_cells << [fields[:answer_id], fields[:value], fields[:row], fields[:col], fields[:answer_type]]
    end
    return new_cells
  end
  
  # input: hash with cell values
  # def create_cells(cells = {}, valid_values = {})
  #   new_cells = []
  #   cells.each do |cell_id, fields|  # hash is {item=>x, value=>y, qtype=>z, col=>a, row=>b}
  #     fields[:answer_id] = self.id
  #     fields[:answertype] = valid_values[cell_id][:type].to_s
  # 
  #     value = fields[:value]
  #     # validates value for rating and selectoption
  #     if valid_values[:type] =~ /Rating|SelectOption/
  #       value = "" if value.blank?     # only save 9 as unanswered for rating and selectoption
  #       fields[:value] = value if valid_values[:fields].include? value # only save valid value
  #       # end
  #     else
  #       fields[:value] = CGI.escape(value.gsub(/\r\n?/,' ').strip)  # TODO: escaping of text (dangerous here!)
  #     end
  #     new_cells << AnswerCell.new(fields) # was: create
  #   end
  #   return new_cells
  # end

  def fill_unanswered_cells(survey_answer)
    add_missing_cells(survey_answer.max_answer)
  end
    
  # returns answer cells which are ratings
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

  def answer_cell_exists?(col, row)
    a_cell = self.answer_cells(true).find(:first, :conditions => ['row = ? AND col = ?', row, col] ) # TODO:, :select => 'id, row, col, value')
    return a_cell
  end

  # returns array of cells to create
  def add_missing_cells_optimized
    a_cells = self.answer_cells.ratings
    count = 0
    # find missing
    cells = a_cells.map {|a| [a.row, a.col] }
    cell_arr = cells.first
    return if !(cell_arr && cell_arr.size == 2) 

    q_cells = self.question.question_cells.ratings.map {|a| [a.row, a.col] }
    q_cells_size = q_cells.size
    missing_cells = q_cells - cells

    new_cells = []
    missing_cells.each do |m_cell|
      row, col = m_cell
      find_row = row - 1 # try one before this
      cells_away = 1 # how far the found cell is from the one to fill in
      while((prev_item = a_cells.detect { |c| c.row == find_row}).nil? && find_row > 0) do
        find_row -= 1
        cells_away += 1
      end
      if prev_item && (item = prev_item.item) && find_row > 0 && find_row < q_cells_size
        cells_away.times { item.succ! }
        unless exists = self.answer_cells(true).find_by_row_and_col(row, col)
          new_cells << self.answer_cells.build(:item => item, :row => row, :col => col, :answertype => 'Rating', :value => '')
          count += 1
          # puts "AC created: #{ac.inspect}, item: #{item}, row: #{row}, m_cell: #{m_cell.inspect}"
        end
      end
      row = col = find_row = cells_away = prev_item = exists = nil
    end if self.survey_answer.done
    puts "COUNT #{count} ANswer #{self.id} q_id #{self.question_id} r,c,i: " + new_cells.map {|c| [c.row, c.col, c.item].join(', ')}.join('  ')
    # count
    new_cells
  end
  
  def add_missing_cells
    a_cells = self.answer_cells.ratings #.map {|a| [a.row, a.col] }
    count = 0
    # find missing
    cells = a_cells.map {|a| [a.row, a.col] }
    cell_arr = cells.first
    return if !(cell_arr && cell_arr.size == 2) 

    q_cells = self.question.question_cells.ratings.map {|a| [a.row, a.col] }
    q_cells_size = q_cells.size
    missing_cells = q_cells - cells
    # puts "Answer: #{answer.id}\nmissing cells: #{missing_cells.inspect}"
    new_cells = []
    missing_cells.each do |m_cell|
      row, col = m_cell
      find_row = row - 1 # try one before this
      cells_away = 1 # how far the found cell is from the one to fill in
      while((prev_item = a_cells.detect { |c| c.row == find_row}).nil? && find_row > 0) do
        find_row -= 1
        cells_away += 1
      end
      # puts "find_row: #{find_row} cells_away: #{cells_away}"
      if prev_item && (item = prev_item.item) && find_row > 0 && find_row < q_cells_size
        cells_away.times { item.succ! }
        # puts "new item: #{item}, m_cell: #{m_cell.inspect} prev_cell: #{prev_item.inspect}"
        unless exists = self.answer_cells(true).find_by_row_and_col(row, col)
          new_cells << ac = self.answer_cells.create(:item => item, :row => row, :col => col, :answertype => 'Rating', :value => '')
          count += 1
          # puts "AC created: #{ac.inspect}, item: #{item}, row: #{row}, m_cell: #{m_cell.inspect}"
        end
      end
      row = col = find_row = cells_away = prev_item = exists = nil
    end if self.survey_answer.done
    puts "COUNT #{count} ANswer #{self.id} q_id #{self.question_id} r,c,i: " + new_cells.map {|c| [c.row, c.col, c.item].join(', ')}.join('  ')
    count
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
