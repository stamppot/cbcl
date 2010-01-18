class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :question_cells, :dependent => :destroy, :order => 'row, col ASC'  # order by row, col
  has_many :answers
  has_many :score_items

  named_scope :by_survey, lambda { |survey| { :conditions => ['survey_id = ?', survey.is_a?(Survey) ? survey.id : survey] } }
  named_scope :and_question_cells, :include => :question_cells

  after_save :update_ratings_count
  
  def update_ratings_count
    self.ratings_count = self.ratings.size
    self.save
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
      params[q_cell] = { :type => question_cell.class.to_s } # TODO: maybe not needed
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
          q_cells[row][col].value = CGI.unescape(a_cells[row][col].value || "") #if q_cells[row][col].eql_cell?(a_cells[row][col])
        end
      end
      return q_cells
    end
  end


  def merge_answertype(answer)
    # "running merge_answertype: #{answer.inspect}"
    if answer.question_id == self.id
      q_cells = self.rows_of_cols
      a_cells = answer.rows_of_cols
      # puts "#merge_answertype #{@@count_runs}: rows #{a_cells.size}  answer: #{answer.id}"
      a_cells.each_pair do |row, cols|           # go thru a_cells to make it faster
        cols.each_pair do |col, cell|
          # puts "set answertype #{q_cells[row][col].type} item: #{q_cells[row][col].answer_item}"
          a_cells[row][col].answertype = q_cells[row][col].type # if q_cells[row][col].eql_cell?(a_cells[row][col])
          a_cells[row][col].item = q_cells[row][col].answer_item
          a_cells[row][col].save
        end
      end
      return a_cells
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

  # set variables from existing var, otherwise create var name
  def set_variables
    prefix = survey.prefix

    q = self.number.to_roman.downcase
    self.question_cells.map do |cell|
      if cell.class.to_s =~ /Rating|Checkbox|ListItemComment|SelectOption|TextBox/
        var = Variable.get_by_question(id, cell.row, cell.col)
        if var
          # puts "Setting cell (#{cell.row},#{cell.col}) i: #{cell.answer_item}: #{var.var}"
          cell.var = var.var
        else
          item = cell.answer_item
          item << "hv" if !(item =~ /hv$/) && cell.type =~ /Comment|Text/
          # if "#{prefix}#{item}" =~ /^ccy$|^ccy1f$|^ccy1g$|^ccy3hv$|^ycy$|^ycy1f$|^ycy1g$/
          #   puts "WARNING: #{cell.inspect} has (wrong?) item: " + "#{prefix}#{item}"
          # else
          # puts "Setting cell (#{cell.row},#{cell.col}) i: #{cell.answer_item}: " + "#{prefix}#{q}#{item}"
          cell.var = "#{prefix}#{q}#{item}"
          # puts "cell: #{cell.items} #{cell.inspect}" if cell.var =~ /ccyviiihandbe/
        end
      else
        cell.var = "" unless cell.var.nil?
        # puts "!!! #{cell.inspect} : #{cell.items}" if cell.items =~ /radio/
        # puts "!!! TRYING to set cell (#{cell.row},#{cell.col}) i: #{cell.answer_item}: " + "#{prefix}#{q}#{item} - WRONG TYPE: #{cell.type}"
      end
      cell.save
    end
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
          # if "#{prefix}#{item}" =~ /^ccy$|^ccy1f$|^ccy1g$|^ccy3hv$|^ycy$|^ycy1f$|^ycy1g$/
          #   puts "WARNING: #{cell.inspect} has (wrong?) item: " + "#{prefix}#{item}"
          # else
          cells["#{prefix}#{q}#{item}".to_sym] = cell.value.blank? && "#NULL!" || cell.value # !! default value is "", not nil
          # end
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
