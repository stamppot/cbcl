class CodeBookQuestion
	attr_accessor :cells
	
	def initialize(question)
		self.cells = question.question_cells.map {|cell| CodeBookCell.new(cell) }
	end

	def to_csv(header = false)
		col = header && [cells.first.csv_header] || []
		(col + cells.map {|cell| cell.to_csv}).join
	end

	def to_a(header = false)
		col = header && [cells.first.csv_header] || []
		cells.each {|cell| col << cell.to_a }
		col.flatten
	end
	
end