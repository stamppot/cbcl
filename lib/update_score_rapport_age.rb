class UpdateScoreRapportAge

	def update_all(do_it = false)
		SurveyAnswer.find_each(:batch_size => 200) do |sa|
			if sa.score_rapport
				sa.update_score_report(do_it)
			else
				sa.generate_score_report(do_it)
			end
		end
	end

	def generate_all(do_it = false)
		SurveyAnswer.find_each(:batch_size => 200) do |sa|
			sa.generate_score_report(do_it)
		end
	end
end