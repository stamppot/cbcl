class Task < ActiveRecord::Base
  belongs_to :export_file

  def create_export(survey_ids, entries)
    self.save

    # spawn do
      entries = JournalEntry.find(entries)
      # data = CSVHelper.new.entries_to_csv(entries, survey_ids)
      data = CSVHelper.new.to_csv(entries, survey_ids)  # TODO: add csv generation on save_answer & change_answer
      # TODO improve
# SELECT survey_answers.survey_id, answers.number, col, row, value 
# FROM survey_answers, answers, answer_cells where survey_answers.id = answers.survey_answer_id
#  AND answers.id = answer_cells.answer_id order by survey_answers.survey_id,number, col,row
      
      # write data
      self.export_file = ExportFile.create(:data => data,
        :filename => "eksport_svar_" + Time.now.to_date.to_s + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.status = "Completed"
      self.save
    # end
    
  end

  def completed?
    self.status == "Completed"
  end

  def completed!
    self.status = "Completed"
    self.save
  end
end