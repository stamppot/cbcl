class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :question_cells, :dependent => :destroy, :order => 'row, col ASC'  # order by row, col
  has_many :answers
  has_many :score_items
  has_many :variables
  named_scope :by_survey, lambda { |survey| { :conditions => ['survey_id = ?', survey.is_a?(Survey) ? survey.id : survey] } }
  named_scope :and_question_cells, :include => :question_cells

  after_save :update_ratings_count
  
  def update_ratings_count
    self.ratings_count = self.ratings.size
  end
  
  # returns question cells which are ratings
  def ratings
    self.question_cells.ratings
  end

  def add_question_cell(question_cell)
    self.question_cells << question_cell
  end

  def valid_values
    params = {}
    self.question_cells.each do |question_cell|
      q_cell = "q#{self.number}_#{question_cell.row}_#{question_cell.col}"
      params[q_cell] = { :type => question_cell.class.to_s, :item => question_cell.answer_item } # TODO: maybe not needed
      unless (values = question_cell.values).empty?
        params[q_cell][:values] = values
      end
    end
    return params
  end
    
  # assumes that arrays of q_cells and a_cells are symmetrical. Where no answer is relevant, a nil value occurs
  def merge_answer(answer)
    if answer.question_id == self.id
      q_cells = self.rows_of_cols
      a_cells = answer.rows_of_cols
      a_cells.each_pair do |row, cols|           # go thru a_cells to make it faster
        cols.each_pair do |col, cell|
					if a_cells[row][col].text?
						q_cells[row][col].value = CGI.unescape(a_cells[row][col].value_text) || CGI.unescape(a_cells[row][col].value)
            # puts "cell is text. qno: #{q_cells[row][col].question.number} Row[#{row}][#{col}] value: #{a_cells[row][col].value} value_text: #{a_cells[row][col].value_text} : #{a_cells[row][col].inspect}"
					else
          	q_cells[row][col].value = "#{a_cells[row][col].value}"
            if(a_cells[row][col].value_text != a_cells[row][col].value.to_s)
          	  q_cells[row][col].value = CGI.unescape(a_cells[row][col].value_text)
            end
					end
        end
      end
      return q_cells
    end
  end

  def get_answertype(row, col)
    cache_fetch("q_type_item_#{self.id}_#{row}_#{col}", :expires_in => 15.minutes) do 
      qc = self.question_cells.first(:conditions => ['question_id = ? AND row = ? AND col = ?', self.id, row, col])
      [qc.class.to_s, qc.answer_item] if qc
    end
  end

  # should do exactly the same as hash_rows_of_cols, and is faster too!
  def rows_of_cols
    result = self.question_cells.inject({}) do |rows, cell|
      rows[cell.row] = {} if rows[cell.row].nil?
      rows[cell.row][cell.col] = cell
      rows
    end
  end

  def rows
    self.question_cells.map { |c| c.row }.uniq
  end

  def cols
    self.question_cells.map { |c| c.col }.uniq
  end
    
  # counts no. rows with an answer_item
  def count_items
    QuestionCell.count("id", :conditions => ["question_id = ? AND answer_item != ? AND col = 2", self.id, "" ])
  end
      
  # comparison based on row number
  def <=>(other)
    self.number <=> other.number
  end

  
  # contains only answerable cells
  def cell_variables(prefix = nil)
    cells = Dictionary.new
    prefix ||= survey.prefix

    q = self.number.to_roman.downcase
    # puts "answerable cells for q: #{self.id} n: #{self.number} :: #{self.question_cells.answerable.count}"
    self.question_cells.map do |cell|
      if cell.class.to_s =~ /Rating|Checkbox|ListItemComment|ListItem|SelectOption|TextBox/
        var = Variable.get_by_question(id, cell.row, cell.col)
        if var
          cells[var.var.to_sym] = cell.value || "#NULL!"
        else  # default var name
          item = cell.answer_item
          item << "hv" if !(item =~ /hv$/) && cell.type =~ /Comment|Text/
          cells["#{prefix}#{q}#{item}".to_sym] = cell.value.blank? && "#NULL!" || cell.value # !! default value is "", not nil
        end
      end
    end
    return cells
  end

  
  def to_xml2
    xml = []
    xml << "<question id='#{self.id.to_s}' >"
    xml << "  <number>#{self.number.to_roman}</number>"
    xml << "  <question_cells>"
    xml << self.question_cells.collect { |question_cell| question_cell.to_xml }
    xml << "  </question_cells>"
    xml << "</question>"
  end
end
