class Task < ActiveRecord::Base
  belongs_to :export_file

  def create_export(survey_ids, survey_answers)
    # self.save

    # spawn do
      # entries = survey_answers.map { |sa| sa.journal_entry }
      data = CSVHelper.new.to_csv(survey_answers, survey_ids)  # TODO: add csv generation on save_answer & change_answer
      # write data
      self.export_file = ExportFile.create(:data => data,
        :filename => "eksport_svar_" + Time.now.to_date.to_s + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.status = "Completed"
      self.save
    # end
  end

  def create_csv_answer(survey_answer)
    spawn do
      survey_answer.create_csv_answer!
    end
  end

  def completed?
    self.status == "Completed"
  end

  def completed!
    self.status = "Completed"
    self.save
  end
  
end