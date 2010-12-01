class CodeBookCell
	attr_accessor :item, :score, :text, :question, :answerable
	
	def initialize(question_cell)
		data = question_cell.row_data
		self.answerable = question_cell.answerable?
		self.item     = data[:item]
		self.score    = data[:score]
		self.text     = data[:text]
		self.question = data[:question]
	end
	
	def csv_header
		"question;;item;;text;;score\n"
	end
	
	def to_csv
		"#{question};;#{item};;#{text};;#{answerable && score.join(', ') || score}\n"
	end

	def arr_header
		%w{question, item, text, score}
	end
	
	def to_a
		[question,item,text,(answerable && score.join(', ') || score)]
	end
	
end