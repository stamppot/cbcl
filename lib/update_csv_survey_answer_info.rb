class UpdateCsvSurveyAnswerInfo

	def update_all(do_it = false)
		CsvSurveyAnswer.find_each(:batch_size => 500) do |csa|
			sa = csa.survey_answer
			next unless sa
			next unless sa.journal
			if sa.center.nil? || sa.sex == 0
				sa.center = sa.journal.center 
				sa.sex = sa.journal.sex
				sa.save
			end
			j = sa.journal
			puts "sa.id: #{sa.journal_id}  t: #{j.parent.id}  c: #{sa.center.title}  age_answer: #{sa.age_when_answered}  Besv: #{sa.info['besvarelsesdato']}"
			csa.journal_info = sa.info.values.join(';;')
			csa.save
		end
	end

	def create_or_update_all(do_it = false)
		SurveyAnswer.find_each(:batch_size => 100) do |sa|
			sa.save_csv_survey_answer
		end
	end
end