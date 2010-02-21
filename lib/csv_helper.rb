require 'fastercsv'
# require 'facets/dictionary'

class CSVHelper

  DEBUG = false
  
  def survey_answer_csv_query(survey_answer)
    query = "select journal_id, journal_entry_id, id, survey_id, age, sex from survey_answers
        where survey_answers.done = 1
        and survey_answers.journal_entry_id != 0
        and survey_answers.id = #{survey_answer.id}
        order by journal_id"    
  end

  def survey_answers_csv_query
    query = "select journal_id, journal_entry_id, id, survey_id, age, sex from survey_answers
    where survey_answers.done = 1
    and survey_answers.journal_entry_id != 0
    order by journal_id"
  end
    
  def csv_answers_values
    csv_from_query(survey_answers_csv_query)
  end
  
  def csv_answer_values(survey_answer)
    csv_from_query(survey_answer_csv_query(survey_answer))
  end
    
  # for one survey_answer
  def generate_csv_answer_line(query)
    result = ActiveRecord::Base.connection.execute(query)

    result.each_hash do |c|  # survey_answer attributes
      values = SurveyAnswer.and_answer_cells.find(c["id"]).to_csv
      answer = FasterCSV.generate_line(values, :col_sep => ";", :row_sep => :auto)
    end
    result.gsub!(/\n$/,'')
  end
      
  def csv_from_query(query)
    result = ActiveRecord::Base.connection.execute(query)

    csv_answers = {}  # generate csv_answer strings
    result.each_hash do |c|
      values = SurveyAnswer.and_answer_cells.find(c["id"]).to_csv
      answer = FasterCSV.generate_line(values, :col_sep => ";", :row_sep => :auto).gsub!(/\n$/,'').chomp
      csv_answers[c["id"]] = [c['id'], c['survey_id'], c['journal_entry_id'], c['journal_id'], c['age'], c['sex'], answer]
    end
    return csv_answers
  end
  
  def generate_csv_answers(csv_answers)  # hash with survey_answer_id => csv_answer string
    # partition into insert and update 
    update_answers = CsvAnswer.all(:conditions => ['survey_answer_id in (?)', csv_answers.keys])
    insert_survey_answer_ids = csv_answers.keys - update_answers.map {|sa| sa.survey_answer_id.to_s}
    insert_survey_answers = insert_survey_answer_ids.map {|sa_id| csv_answers[sa_id]}.compact # new survey answers    
    update_answers.each { |ca| ca.answer = csv_answers[ca.survey_answer_id.to_s].last } # add answer string
    
    # insert
    columns = [:survey_answer_id, :survey_id, :journal_entry_id, :journal_id, :age, :sex, :answer]
    if insert_survey_answers.any?
      t = Time.now; insert_ca_o = CsvAnswer.import(columns, insert_survey_answers, :on_duplicate_key_update => [:answer]); e = Time.now
      puts "Time to insert #{insert_ca_o.size} survey_answers: #{e-t}"
    end
    # update
    if update_answers.any?
      t = Time.now; updated_ca_no = CsvAnswer.import([:id, :answer], update_answers, :on_duplicate_key_update => [:answer]); e = Time.now
      puts "Time to update #{update_answers.size} survey_answers: #{e-t}"
    end
  end
  
  def create_survey_answer_csv(survey_answer)
    generate_csv_answers(csv_answer_values(survey_answer))
  end
  
  def generate_all_csv_answers
    generate_csv_answers(csv_answers_values)
  end


  # merged pregenerated csv_answer string with header and journal information
  def to_csv(entries, survey_ids)
    # get survey_answers
    survey_answers = entries.map {|e| e.survey_answer_id }
    journal_ids = entries.build_hash { |elem| [elem.journal_id, elem.survey_id] }
    
    # create csv headers
    csv_headers = survey_headers(survey_ids)
    csv_headers.each { |s_id, hash| csv_headers[s_id] = hash.values.join(';') } #null! values
    
    # csv_headers = journal_csv_header.merge
    result = {}
    journal_ids.each do |j, survey_ids|
      csv_answers = CsvAnswer.by_journal_and_surveys(j, survey_ids).map {|ca| ca.answer.chomp.gsub!(/^\"|\n"$/, ""); ca}.group_by { |c| c.survey_id }
      csv_headers.each do |s_id, empty_vals|       # fill missing values for surveys not answered for this journal
        csv_answers[s_id] = csv_answers[s_id] && csv_answers[s_id].first.answer.chomp || empty_vals 
      end
      result[j] = [csv_answers.values.join(';')]
    end

    # add journal info # todo: prefetch wanted journals
    rows = result.map do |j, answers|
      journal = Journal.find(j)
      ((journal_to_csv(journal) + answers)).join(';')
    end 

    output = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv_output|
      csv_output << (journal_csv_header.keys + survey_headers_flat(survey_ids).keys)  # header
      rows.each { |line| csv_output << line}
    end
  end
  
  
  # TODO: does not work!
  def login_users(journals)
    journals = journals.select { |journal| journal.journal_entries.any? {|e| e.not_answered? && e.login_user } }
    
    puts "journals with unanswered entries: #{journals.size}" if DEBUG
    # {"journal_155"=> {
    #   :skemaer => [{:user=>"abc-login17", :survey=>"YSR: 11-16 år", :password=>"tog4pap9", :date=>"23-10-08"}],
    #   :navn=>"Frederik Fran Søndergaard" } }
    results = journals.inject({}) do |results, journal|
      surveys = journal.journal_entries.inject([]) do |col, entry|
        if entry.login_user && entry.not_answered?
          survey_name = entry.survey.title.gsub(/\s\(.*\)/,'')
          an_entry = { :user => entry.login_user.login, :password => entry.password,
            :survey => survey_name, :date => entry.created_at.strftime("%d-%m-%y") }
          col << an_entry
        end
        col
      end

      results["journal_#{journal.code}"] = { 
        :navn => journal.person_info.name,
        :skemaer => surveys
      } if !surveys.empty?

      results
    end

    puts "results size: #{results.size}"  if DEBUG
    # max no surveys in any journal
    max = results.values.map {|h| h[:skemaer] }.max { |a,b| a.size <=> b.size }.size
    
    csv = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv|
      header = ["id", "navn"]
      max.times do |i| 
        s = "skema_#{i+1}"
        header += [s, "#{s}_login", "#{s}_password", "#{s}_dato"]
      end
      csv << header
      
      contents = []
      results.each do |journal, hash|
        row = [journal, hash[:navn]]
        results[journal][:skemaer].each do |survey|
          row << survey[:survey]
          row << survey[:user]
          row << survey[:password]
          row << survey[:date]
        end
        # puts "cols: #{row.size}  max: #{max}"
        s = row.size
        (max*4-s+2).times { |i| row << "" } # fill row with empty values
        # puts "cols: #{row.size}  max: #{max}"

        contents << row
        contents = contents.sort { |a,b| a.first <=> b.first }
      end
      contents.each { |row| csv << row }
    end
    
    return csv
  end
  
  # header vars grouped by survey
  def survey_headers(survey_ids)
    # s_headers = Rails.cache.fetch("survey_headers_#{survey_ids.join('-')}", :expires_in => 15.minutes) do
      ss = Survey.find(survey_ids)
      ss.inject(Dictionary.new) { |hash, s| hash[s.id] = s.cell_variables; hash }.order_by
    # end
  end

  def survey_headers_flat(survey_ids)
    s_headers = Rails.cache.fetch("survey_headers_flat_#{survey_ids.join('-')}", :expires_in => 15.minutes) do
      ss = Survey.find(survey_ids)
      ss.map { |s| s.cell_variables }.foldl(:merge)
    end
  end
  
  # var => val, grouped by survey
  def survey_answers_groups(survey_answers)
    result = survey_answers.inject(Dictionary.new) do |hash, sa|
      hash[sa.survey_id] = sa.to_csv
      hash
    end
    result.order_by
  end

  def join_table_survey_answers_mixed(survey_ids, entries)
    s_headers = survey_headers_flat(survey_ids)
    
    t1 = Time.now
    survey_answers = entries.map {|e| e.survey_answer_id }
    sa_table = survey_answers.inject(Dictionary.new) do |h, sa|
      sa_obj = Rails.cache.fetch("survey_answer_#{sa}") do SurveyAnswer.and_answer_cells.find_by_id(sa) end
      h[sa] = sa_obj.cell_values unless sa_obj.blank?
      h
    end    # join table (hash)
    e1 = Time.now
    puts "PROFILE join_table_survey_answers_mixed, cell_values: #{e1-t1}"
    # duplicate_check = check_duplicate_survey_answers_per_journal(entries)
    
    query = Query.new
    tbl_j_sa = query.query_journal_to_survey_answers(survey_ids, entries.map {|e| e.id })
    
    t3 = Time.now
    # tbl_j_sa.each { |j, sa_ids| puts "j_sa: #{j}: #{sa_ids.inspect}"}
    tbl_j_sa.each do |j, sa_ids|  # merge survey answers with survey headers
      tbl_j_sa[j] = s_headers.merge(sa_ids.map { |sa_id| sa_table[sa_id.to_i] }.foldl(:merge!)).values
    end
    e3 = Time.now
    puts "PROFILE join_table_survey_answers_mixed, headers_merge: #{e3-t3}"
    
    # TODO: add journal_info
    tbl_j_sa
  end

  def journal_table_to_csv(table_journals_sas, s_headers)
    journals = Rails.cache.fetch("journals_#{table_journals_sas.keys.join('_')}", :expires_in => 3.minutes) do
      Journal.find(table_journals_sas.keys).to_hash_with_key { |j| j.id } #.inject({}) { |col, j| col[j.id] = j; col }
    end
    headers = journal_csv_header.merge(s_headers)
  
    csv = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv|
      csv << headers.keys
      
      contents = []
      table_journals_sas.each do |journal, vals|
        row = [journals[journal].to_csv, vals].flatten
        contents << row
      end
      contents.each { |row| csv << row }
    end
    return csv
  end

  def filter_valid_entries(entries)
    # entries.each { |e| puts "NOT AN ENTRY: #{e.inspect}" unless e.is_a?(JournalEntry)}
    entries.map { |e| e.valid_for_csv? }.compact
  end
  
  # This one does the complete job
  def entries_to_csv(entries, survey_ids)
    s_headers = survey_headers_flat(survey_ids)
    entries = filter_valid_entries(entries)
    journal_table_to_csv(join_table_survey_answers_mixed(survey_ids, filter_valid_entries(entries)), s_headers)
  end
    
  # fill survey answers where no survey has been answered
  def fill_csv_answer(survey_headers, answer_values)
    # t = Time.now
    results = Dictionary.new
    survey_headers.each do |survey_id, h_group|
      s = results[survey_id] = Dictionary.new
      
      a_s = answer_values[survey_id] # TODO use this instead of below in !if
      h_group.each do |key, rest|  # fill in blanks
        if !(a_g = answer_values[survey_id])  # fill where survey is missing
          s[key] = ""
        else
          s[key] = a_g[key]
        end
      end
    end
    results
  end
 
  # works, but slow
  def journal_entries(entries)
    t = Time.now
    survey_ids = entries.map {|e| e.survey_id}.uniq
    s_headers = survey_headers(survey_ids)
    headers = journal_csv_header.merge(s_headers)
    e = Time.now
    puts "generate survey_headers: #{e-t}"
    # by journal, get all survey_answers, grouped by entry_id
    sa_ids = entries.map { |e| e.survey_answer_id }
    sas = SurveyAnswer.with_journals.for_surveys(survey_ids).all(:conditions => ['survey_answers.id IN (?)', sa_ids], :include => {:answers => :answer_cells})   # add survey_id contraint for indexes

    group_by_journal = sas.build_hash { |elem| [elem.journal_entry.journal, elem] } # TODO: test
    e1 = Time.now
    
    # for each answer in journal, fill answer
    rows = []
    # count_fill = 0
    group_by_journal.each_with_index do |tuple, i|
      journal = tuple.first
      journal_info = Dictionary.new
      journal_info[:journal] = journal.to_csv
      # s_headers.each do |survey_id, |
      filled_answers = fill_csv_answer(s_headers, survey_answers_groups(tuple.last)) # sas for all entries in one journal
      # count_fill += 1
      rows << journal_info.merge(filled_answers)
    end
    e2 = Time.now
    # puts "Time journal_entries get all answers: #{e1-t}"
    # puts "Time journal_entries total: #{e2-t}"
    # puts "Count fill_csv_answer: #{count_fill}"
    rows
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
    info(journal).values
  end
  
  # info on journal in array of hashes
  def info(journal)
    # h = []
    c = Dictionary.new # ActiveSupport::OrderedHash.new
    c["ssghafd"] = journal.parent.group_code
    c["ssghnavn"] = journal.center.title
    c["safdnavn"] = journal.team.title
    c["pid"] = journal.code
    c["pkoen"] = journal.sex
    c["palder"] = journal.age  # TODO: alder skal være alder på besvarelsesdatoen
    c["pnation"] = journal.nationality
    c["dagsdato"] = journal.created_at.strftime("%d-%b-%Y")
    c["pfoedt"] = journal.birthdate.strftime("%d-%b-%Y")  # TODO: translate month to danish
    c
  end
end