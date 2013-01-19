require 'fastercsv'
# require 'facets/dictionary'

class ExportAnswersHelper

  def to_danish(str)
    if str.respond_to? :gsub
      str.gsub("Ã¸", "ø").gsub("Ã¦", "æ").gsub("Ã…", "Å")
    else
      str
    end
  end

  def generate_header(journal)
    h = %w{ssghafd ssghnavn safdnavn pid projekt pkoen palder pnation besvarelsesdato pfoedt}.join(';;')
    csv_survey_answers = CsvSurveyAnswer.find_all_by_journal_id(journal.id)
    csv_survey_answers.each {|c| c.header =  h; c.save }
  end

  def score_rapports_to_csv(csv_score_rapports, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.scores.map {|s| s.variable}
    
    csv_rows = csv_score_rapports.inject([]) do |rows,csa|
      rows << csa.journal.info.values.map {|v| to_danish(v)} + csa.answer.split(';;')
      rows
    end

    output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto, :encoding => 'u') do |csv_output|
      csv_output << header
      csv_rows.each { |line| csv_output << line }
    end
  end
    
  # merged pregenerated csv_answer string with header and journal information
  def export_survey_answers(csv_survey_answers, survey_id)
    survey = Survey.find(survey_id)
    header = journal_csv_header.keys + survey.variables.map {|v| v.var}
    
    csv_rows = csv_survey_answers.inject([]) do |rows,csa|
      header_values = csa.journal_info.split(';')  # csa.journal.info.values
      # rows << csa.journal_info.split(';') + csa.answer.split(';;')
      rows << header_values + csa.answer.split(';;')
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
    keys = %w{ssghafd ssghnavn safdnavn pid projekt pkoen palder pnation besvarelsesdato pfoedt}
    keys.inject(Dictionary.new) {|h, key| h[key] = nil; h }
  end

  def journal_to_csv(journal)
    journal.info.values
  end
  
end