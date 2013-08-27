class CellJson

	attr_accessor :val, :row, :col, :question_no, :css_id

	def initialize(answer_cell)
		self.val = answer_cell.value_text || (answer_cell.rating && answer_cell.value == 9 && "" || answer_cell.value)
		self.row = answer_cell.row
		self.col = answer_cell.col
		self.question_no = answer_cell.answer.question.number.to_s
		self.css_id = ["q"+self.question_no, self.row, self.col].join("_")
	end


end