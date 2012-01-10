require 'fastercsv'
# require 'facets/dictionary'

class CsvExportHelper

  def to_danish(str)
    # str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
  end
  
  # merged pregenerated csv_answer string with header and journal information
  def to_csv(csv_survey_answers, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.variables.map {|v| v.var}
    
    csv_rows = csv_survey_answers.inject([]) do |rows,csa|
      rows << csa.journal_info.split(';') + csa.answer.split(';;')
      rows
    end

    output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'u') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end

  # header vars grouped by survey
  def survey_headers(survey_id)
    s = Survey.find(survey_id)
    s.variables.map {|var| var.var}
  end

  def journal_csv_header
    c = Dictionary.new
    c["ssghafd"] = nil
    c["ssghnavn"] = nil
    c["safdnavn"] = nil
    c["pid"] = nil
    c["pkoen"] = nil
    c["palder"] = nil
    c["pnation"] = nil
    c["dagsdato"] = nil
    c["pfoedt"] = nil
    c
  end

  def journal_to_csv(journal)
    journal.info.values
  end
  
end