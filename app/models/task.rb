class Task < ActiveRecord::Base
  belongs_to :export_file

  def create_export(survey_ids, entries)
    self.save

    # spawn do
      entries = JournalEntry.find(entries)
      data = CSVHelper.new.to_csv(entries, survey_ids)  # TODO: add csv generation on save_answer & change_answer
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
      puts "Generating CSVAnswer for SurveyAnswer #{survey_answer.id}"
      CSVHelper.new.create_csv_answer(survey_answer)
      puts "Generated " + CsvAnswer.find_by_survey_answer_id(survey_answer.id).inspect
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