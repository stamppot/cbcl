# require 'fastercsv'

# class CsvScores
  
#   # merged pregenerated csv_answer string with header and journal information
#   def to_csv(score_reports)
#     journal_ids = score_reports.sort_by {|sr| sr.survey_id}.build_hash { |sr| [sr.survey_answer.journal_id, sr.survey_id] }
#     survey_ids = journal_ids.values.flatten.uniq
    
#     # create csv headers
#     csv_headers = score_report_headers(score_reports)
#     csv_headers.each { |s_id, hash| csv_headers[s_id] = hash.values.join(';') } #null! values
    
#     result = {}
#     journal_ids.each do |j, survey_ids|
#       csv_answers = CsvAnswer.by_journal_and_surveys(j, survey_ids).map {|ca| ca.answer.chomp.gsub!(/^\"|\n"$/, ""); ca}.group_by { |c| c.survey_id }
#       csv_headers.each do |s_id, empty_vals|       # fill missing values for surveys not answered for this journal
#         je = Journal.find(j).journal_entries.map &:survey
#         # puts "MISSING csv: j_id: #{j} code: #{Journal.find(j).code} s: #{s_id} journal has surveys: #{je.map &:title}" unless csv_answers[s_id]
#         csv_answers[s_id] = csv_answers[s_id] && csv_answers[s_id].first.answer.chomp || empty_vals 
#       end
#       result[j] = [csv_answers.values.join(';')]
#     end

#     # add journal info # todo: prefetch wanted journals
#     rows = result.map do |j, answers|
#       journal = Journal.find(j)
#       ((journal_to_csv(journal) + answers)).join(';')
#     end 

#     output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
#       csv_output << (journal_csv_header.keys + survey_headers_flat(survey_ids).keys)  # header
#       rows.each { |line| csv_output << line.gsub(/^\"|\"$/, "").split(";") }
#     end
#   end  
  
  
#   def score_report_headers(score_reports)
#     score_reports.inject(Dictionary.new) { |hash, sr| hash[sr.survey_id] = sr.score_results.map &:title; hash }.order_by
#   end
  
  
  
# end