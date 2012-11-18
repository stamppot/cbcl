class AnswerFromLog

	def save_draft(params = {})
    	journal_entry = JournalEntry.and_survey_answer.find(params["id"])
    	journal_entry.draft!
    	return if journal_entry.answered?

    	if journal_entry.survey_answer.nil? || !journal_entry.answered?
      	journal_entry.make_survey_answer
      	journal_entry.survey_answer.save
    	end
	    survey_answer = journal_entry.survey_answer
    	survey_answer.done = false
		survey_answer.journal_entry_id ||= journal_entry.id
		survey_answer.set_answered_by(params)
	    survey_answer.save_answers(params)
		survey_answer.center_id ||= journal_entry.journal.center_id
    	survey_answer.save
    	survey_answer
	end
end