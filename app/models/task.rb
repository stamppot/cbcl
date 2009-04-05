class Task < ActiveRecord::Base
  belongs_to :export_file

  def create_export(survey_ids, entries)
    self.save

    spawn do
      entries = JournalEntry.find(entries)
      data = CSVHelper.new.entries_to_csv(entries, survey_ids)
      
      # write data
      self.export_file = ExportFile.create(:data => data,
        :filename => "eksport_svar_" + Time.now.to_date.to_s + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.status = "Completed"
      self.save
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