class Task < ActiveRecord::Base
  belongs_to :export_file

  def create_export(survey_ids, survey_answers)
    spawn do
      data = CSVHelper.new.to_csv(survey_answers, survey_ids)  # TODO: add csv generation on save_answer & change_answer
      # write data
      self.export_file = ExportFile.create(:data => data,
        :filename => "eksport_svar_" + Time.now.to_date.to_s + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.status = "Completed"
      self.save
    end
  end

  def create_survey_answer_export(survey_id, survey_answers)
    spawn do
      data = ExportHelper.new.to_csv(survey_answers, survey_id)  # TODO: add csv generation on save_answer & change_answer
      # write data
      self.export_file = ExportFile.create(:data => data,
        :filename => "eksport_svar_" + Time.now.to_date.to_s + ".csv",
        :content_type => "application/vnd.ms-excel")

      self.status = "Completed"
      self.save
    end
  end

  def create_sumscores_export(find_options)
    spawn do
      score_rapports = ScoreRapport.find_with_options(find_options)
      # write data
      t = Time.now
      self.export_file = ExportFile.create(:data => ZScoreGroup.to_xml(score_rapports.map {|sr| sr.score_results}).flatten,
        :filename => "sumscores_eksport" + Time.now.to_date.to_s + ".xml",
        :content_type => "text/xml")
      e = Time.now
      puts "create_sumscores_export: #{e-t}"
      self.status = "Completed"
      self.save
    end
  end

  def create_csv_answer(survey_answer)
    spawn do
      survey_answer.create_csv_answer!
    end
  end

  def create_csv_survey_answer(survey_answer)
    spawn do
      survey_answer.save_csv_survey_answer
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