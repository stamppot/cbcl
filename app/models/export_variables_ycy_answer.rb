class ExportVariablesYcyAnswer < ActiveRecord::Base
  belongs_to :export_journal_info

  def self.exists(survey_answer)
    self.find_by_journal_id_and_survey_answer_id(survey_answer.journal_id, survey_answer.id, :select => [:id])
  end

end