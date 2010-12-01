class CodeBook
	attr_accessor :survey, :questions
	
	def initialize(survey)
		self.survey = survey
		self.questions = survey.questions.map {|question| CodeBookQuestion.new(question) }
	end

	def to_csv
		([csv_header] + questions.map {|q| q.to_csv}).join
	end
	
	def to_a
		([arr_header] + questions.map {|q| q.to_a})
	end
	
	private
	def csv_header
		questions.first.cells.first.csv_header
	end

	def arr_header
		questions.first.cells.first.arr_header
	end

end