require 'fastercsv'
require 'facets/dictionary'

class CSVHelper

  DEBUG = false
  
  # TODO: does not work!
  def login_users(journals)
    journals = journals.select { |journal| journal.journal_entries.any? {|e| e.not_answered? && e.login_user } }
    
    puts "journals with unanswered entries: #{journals.size}" if DEBUG
    # {"journal_155"=> {
    #   :skemaer => [{:user=>"abc-login17", :survey=>"YSR: 11-16 år", :password=>"tog4pap9", :date=>"23-10-08"}],
    #   :navn=>"Frederik Fran Søndergaard" } }
    results = journals.inject({}) do |results, journal|
      surveys = journal.journal_entries.inject([]) do |col, entry|
        puts "entry: #{entry.inspect}"
        if entry.login_user && entry.not_answered?
          survey_name = entry.survey.title.gsub(/\s\(.*\)/,'')
          an_entry = { :user => entry.login_user.login, :password => entry.password,
            :survey => survey_name, :date => entry.created_at.strftime("%d-%m-%y") }
          col << an_entry
          puts "entry #{entry.id}: #{an_entry.inspect}"
        end
      end

      puts "surveys: #{surveys.inspect}"  if DEBUG
      puts "results size1: #{results.size}  #{results.inspect}"  if DEBUG
      results["journal_#{journal.code}"] = { 
        :navn => journal.person_info.name,
        :skemaer => surveys
      } if !surveys.empty?

      results
    end

    puts "results size: #{results.size}"  if DEBUG
    # max no surveys in any journal
    results.values.each { |r| puts "R: #{r.inspect}"}
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

  def order_by_survey(survey_answers)
    survey_answers.sort_by {|sa| sa.survey_id}.group_by {|sa| sa.survey_id }
  end
  
  
  # header vars grouped by survey
  def survey_headers(survey_ids)
    ss = Survey.find(survey_ids, :include => {:questions => :question_cells})
    ss.inject(Dictionary.new) { |hash, s| hash[s.id] = s.cell_variables; hash }.order_by
  end
  
  def survey_headers_arr(survey_ids)
    ss = Survey.find(survey_ids, :include => {:questions => :question_cells})
    ss.inject(Dictionary.new) { |hash, s| hash[s.id] = s.cell_variables; hash }.order_by
  end
  
  def survey_headers_flat(survey_ids)
    ss = Survey.find(survey_ids, :include => {:questions => :question_cells})
    ss.map { |s| s.cell_variables }.foldl(:merge)
  end
  
  # var => val, grouped by survey
  def survey_answers_groups(survey_answers)
    t = Time.now
    result = survey_answers.inject(Dictionary.new) do |hash, sa|
      hash[sa.survey_id] = sa.to_csv
      hash
    end
    e = Time.now
    # puts "survey_answer_groups: #{e-t}   for survey_answers: #{survey_answers.size}"
    result.order_by
  end
  
  def survey_answers_values2(survey_answers)
    survey_answers.inject({}) do |hash,sa|
      h = hash[sa.id] = {}
      if h[sa.survey_id]
        h[sa.survey_id] << sa.cell_values
      else
        h[sa.survey_id] = [sa.cell_values]
      end
      hash
    end
  end
  
  # entry => survey => vars => vals
  def sa_values_by_entry3(survey_answers)
    survey_answers.sort {|a,b| a.survey_id <=> b.survey_id }.inject(Dictionary.new) do |hash,sa|
      hash[sa.journal_entry_id] = Dictionary.new
      hash[sa.journal_entry_id][sa.survey_id] = sa.cell_values
      hash[sa.journal_entry_id].order_by
      hash
    end
  end
  

  def mix(vars, vals, with_vars = true)
    vars.each do |survey_id, varsh|
      if vals[survey_id]
        vals[survey_id] = varsh.merge(vals[survey_id])
        unless with_vars
          vals[survey_id] = vals[survey_id].values
        end
        # differences = (varsh.keys - vals[survey_id].keys)
        # puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!NO MATCH: #{differences.inspect}" unless differences.empty?
      end
    end
    return vals
  end
  
  # extracts survey_answers from entries
  # output : h{journal_id => [sa_ids]}
  def join_table_journal_survey_answers(entries)
    dupes = Dictionary.new
    journal_table = entries.inject(Dictionary.new) do |h, e| 
      if e.survey_answer_id
        # check for duplicates, split into new journal
        if dupes[e.journal_id]
          if dupes[e.journal_id].include? e.survey_id
            # split into dupe journal
            # if dupes["dup#{e.journal_id}"]
            #   dupes["dup#{e.journal_id}"] << e.survey_id
            #   h["dup#{e.journal_id}"] << e.survey_answer_id
            # else
            #   dupes["dup#{e.journal_id}"] = [e.survey_id]
            #   h["dup#{e.journal_id}"] = [e.survey_answer.id]
            # end
            puts "WARNING SURVEY_ANSWER FOR THIS SURVEY ALREADY EXISTS! journal: #{e.journal_id} sa: #{e.survey_id}  #{dupes[e.journal_id].inspect}"
          else
            dupes[e.journal_id] << e.survey_id
          end
        else
          dupes[e.journal_id] = [e.survey_id]
        end
        # insert normal
        if e.valid_for_csv?
          if h[e.journal_id]
            h[e.journal_id] << e.survey_answer_id
          else
            h[e.journal_id] = [e.survey_answer_id]
          end
        else
          puts "NOT VALID: #{e.inspect}"
        end
      end
      h
    end # join table entry->journal
  end

  def check_duplicate_survey_answers_per_journal(entries)
    journal_table = entries.inject(Dictionary.new) do |h, e| 
      if e.survey_id
        if h[e.journal_id]
          if h[e.journal_id].include? e.survey_id
            puts "WARNING SURVEY_ANSWER FOR THIS SURVEY ALREADY EXISTS! journal: #{e.journal_id} sa: #{e.survey_answer_id} s: #{e.survey_id}  #{h[e.journal_id].inspect}"
          else
            h[e.journal_id] << e.survey_id
          end
        else
          h[e.journal_id] = [e.survey_id]
        end
      end
      h
    end # join table entry->journal
  end

  def table_survey_answer_journal(entries)
    entries.inject(Dictionary.new) do |h, e| 
      h[e.survey_answer_id] = e.journal_id if e.survey_answer_id
      h
    end # join table sa_id->journal
  end

  def join_table_survey_answers_mixed(survey_ids, entries)
    t = Time.now; s_headers = survey_headers_flat(survey_ids); e = Time.now
    puts "generate survey_headers: #{e-t}"
    # headers = Journal.csv_header.merge(s_headers)
    
    survey_answers = entries.map {|e| e.survey_answer_id }    # sa_id => {survey_id => vars (for this survey)} 
    sa_table = survey_answers.inject(Dictionary.new) do |h, sa|
      sa_obj = Rails.cache.fetch("survey_answer_#{sa}") do SurveyAnswer.and_answer_cells.find_by_id(sa) end
      if sa_obj.blank?
        puts "HEHEUHUH? #{sa_obj}  #{h[sa]}"
      end
      h[sa] = sa_obj.cell_values if sa_obj
      # h[sa.id] = Answer.all(:include => :answer_cells, :conditions => ['survey_answer_id = ?', sa], :order => 'number', :select => 'id, survey_answer_id').map {|a| a.cell_values}.flatten.foldl(:merge!)
      h
    end    # join table (hash)

    # duplicate_check = check_duplicate_survey_answers_per_journal(entries)
    tbl_j_sa = join_table_journal_survey_answers(entries)
    
    t = Time.now
    # output = Dictionary.new
    # tbl_j_sa.each do |j, sa_ids|  # merge survey answers with survey headers
    #   output[j] = s_headers.merge(sa_ids.map { |sa_id| sa_table[sa_id] }.foldl(:merge))#.values
    # end

    tbl_j_sa.each do |j, sa_ids|  # merge survey answers with survey headers
      # puts "tbl_j_sa. j: #{j.inspect}  sa_ids: #{sa_ids.inspect}"
      tbl_j_sa[j] = s_headers.merge(sa_ids.map { |sa_id| sa_table[sa_id] }.foldl(:merge!)).values
    end
    e = Time.now
    puts "mix and merge: #{e-t}"

    # TODO: add journal_info
    tbl_j_sa
  end

  def journal_table_to_csv(table_journals_sas, s_headers)
    journals = Rails.cache.fetch("journals_#{table_journals_sas.keys.join('_')}", :expires_in => 3.minutes) do
      Journal.find(table_journals_sas.keys).inject({}) { |col, j| col[j.id] = j; col }
    end
    headers = Journal.csv_header.merge(s_headers)
  
    csv = FasterCSV.generate(:col_sep => ";", :row_sep => :auto) do |csv|
      csv << headers.keys
      
      contents = []
      table_journals_sas.each do |journal, vals|
        row = [journals[journal].to_csv, vals].flatten
        # puts "VALS: #{vals.inspect}"
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
    journal_table_to_csv(join_table_survey_answers_mixed(survey_ids, filter_valid_entries(entries)), s_headers)
  end
  
  def mixes(entries, survey_headers, grouped_answers)
    entry_hash = entries.inject(Dictionary.new) { |hash, e| hash[e.id] = e.journal_id; hash }
    puts "entry_hash: #{entry_hash.inspect}"
    d = Dictionary.new
    journals = Dictionary.new
    grouped_answers.each do |entry_id, survey_hash|
      journals[entry_hash[entry_id]] = []
      # puts "entry_id in grouped_answers: #{entry_id}"
      # puts "survey_hash: #{survey_hash.inspect} #{survey_hash.class}"
      d[entry_hash[entry_id]] = Dictionary.new
      d[entry_hash[entry_id]][entry_id] = Dictionary.new
      
      journals[entry_hash[entry_id]] << mix(survey_headers, survey_hash)
      if d[entry_hash[entry_id]][entry_id] # key is journal_id
        d[entry_hash[entry_id]][entry_id] = mix(survey_headers, survey_hash)
      end
    end
    # d
    return journals
  end
  
  def survey_ids(survey_answers) survey_answers.map { |sa| sa.survey_id }.uniq! end
    
  # fill survey answers where no survey has been answered
  def fill_csv_answer(survey_headers, answer_values)
    # t = Time.now
    results = Dictionary.new
    survey_headers.each do |survey_id, h_group|
      s = results[survey_id] = Dictionary.new
      
      a_s = answer_values[survey_id] # TODO use this instead of below in !if
      h_group.each do |key, rest|  # fill in blanks
        # puts "fillcsv: key: #{key}"
        if !(a_g = answer_values[survey_id])  # fill where survey is missing
          s[key] = ""
        else
          s[key] = a_g[key]
        end
      end
    end
    # e = Time.now
    # puts "Time fill_csv_answer: #{e-t}"
    # answer_group
    results
  end
  
  # convert result from survey_answers to array of rows with journal_info, survey_answers1, survey_answers2, etc.
  def hashes_to_csv(arr)
    t = Time.now
    results = []
    as = arr.map do |hash|
      group = []
      hash.each do |key,val|
        val.each { |v, k| group << v << k }
      end
      results << group
    end
    e = Time.now
    puts "Time hashes_to_csv: #{e-t}"
    results
  end

  # works, but slow
  def journal_entries(entries)
    t = Time.now
    survey_ids = entries.map {|e| e.survey_id}.uniq
    s_headers = survey_headers(survey_ids)
    headers = Journal.csv_header.merge(s_headers)
    e = Time.now
    puts "generate survey_headers: #{e-t}"
    # by journal, get all survey_answers, grouped by entry_id
    sa_ids = entries.map { |e| e.survey_answer_id }
    sas = SurveyAnswer.with_journals.for_surveys(survey_ids).all(:conditions => ['survey_answers.id IN (?)', sa_ids], :include => {:answers => :answer_cells})   # add survey_id contraint for indexes

    group_by_journal = sas.inject({}) do |hash, sa|
      j = sa.journal_entry.journal
      if hash[j]
        hash[j] << sa
      else
        hash[j] = [sa]
      end
      hash
    end
    e1 = Time.now
    
    # for each answer in journal, fill answer
    rows = []
    count_fill = 0
    group_by_journal.each_with_index do |tuple, i|
      journal = tuple.first
      journal_info = Dictionary.new
      journal_info[:journal] = journal.to_csv
      # s_headers.each do |survey_id, |
      filled_answers = fill_csv_answer(s_headers, survey_answers_groups(tuple.last)) # sas for all entries in one journal
      count_fill += 1
      rows << journal_info.merge(filled_answers)
    end
    e2 = Time.now
    puts "Time journal_entries get all answers: #{e1-t}"
    puts "Time journal_entries total: #{e2-t}"
    puts "Count fill_csv_answer: #{count_fill}"
    rows
  end

  # def journal_entries3(entries)
  #   t = Time.now
  #   survey_ids = entries.map {|e| e.survey_id}.uniq
  #   s_headers = survey_headers_arr(survey_ids)
  #   headers = Journal.csv_header.merge(s_headers)
  #   
  #   result = join_table_survey_answers_mixed(s_headers, entries)
  #   e = Time.now
  #   puts "Time journal_entries3: #{e-t}"
  #   result
  # end
  
  def journal_entries2(entries)
    t = Time.now
    survey_ids = entries.map {|e| e.survey_id}.uniq
    s_headers = survey_headers_arr(survey_ids)
    headers = Journal.csv_header.merge(s_headers)

    #answers ids grouped by journal
    # journal_id => [survey_answer_ids]
    journal_entry_mapping = entries.inject({}) do |hash, entry|
      j = entry.journal_id
      if hash[j]
        hash[j] << entry.id
      else
        hash[j] = [entry.id]
      end
      hash
    end
    e1 = Time.now
    
    # by journal, get all survey_answers, grouped by entry_id
    sa_ids = entries.map { |e| e.survey_answer_id }
    sas = SurveyAnswer.with_journals.for_surveys(survey_ids).all(:conditions => ['survey_answers.id IN (?)', sa_ids], :include => {:answers => :answer_cells})   # add survey_id contraint for indexes

    t2 = Time.now
    group_by_entry = sa_values_by_entry3(sas)
    e2 = Time.now
    # return group_by_entry
    
    # combine entries per journal
    puts "Time sa_values_by_entry: #{e2-t2}"

    t5 = Time.now
    journals = Journal.find(journal_entry_mapping.keys).inject({}) {|col,j| col[j.id] = j; col}
    e5 = Time.now
    puts "Time fetch journals: #{e5-t5}"
    # collect survey_answers per journal
        
    # return [group_by_entry, journal_entry_mapping]
    
    # return group_by_entry
    # journals = {}
    t3 = Time.now
    
    filled_answers = mixes(entries, s_headers, group_by_entry)
    
    pairs = filled_answers.inject(Dictionary.new) do |hash, rest|
      # puts "rest: #{rest.inspect}"
      journal = rest.shift
      rest.each do |entry_key|
        hash[journal] = []
        entry_key.each do |entry, sa_key|
          # puts "entry_keys: #{entry_key.keys.inspect}"
          # puts "entry_key: #{entry_key.inspect}   sa_key #{sa_key.inspect}"
          sa_key.each { |answers| puts "answers: #{answers.first}: #{answers.last.inspect}"; hash[journal] << answers.last }  # last, since sort converts {a=>b} to [a,b]
        end
      end
      hash
    end
    # return pairs
    
    t4 = Time.now
    pairs = []
    journal_entry_mapping.each do |journal, entry_ids|
      puts "filled_answers[e_id]: #{entry_ids.map { |e_id| filled_answers[e_id] }}"
      f_answers = entry_ids.map { |e_id| filled_answers[journal][e_id] }
      pairs << [journals[journal], f_answers]
    end
    e3 = Time.now
    puts "mapping journal to answers: #{e3-t4}"
    puts "Time journal to answer mapping and mixing: #{e3-t3}"
    
    e2 = Time.now
    puts "Time journal_entries get all answers: #{e1-t}"
    puts "Time journal_entries total: #{e2-t}"

    pairs
  end
  
  def make_csv(pairs)
    pairs.map do |pair|
      [pair.first.to_csv, pair.second]
    end
  end
      
  def find_missing(csv_answers)
    first = csv_answers.shift
    result = []
    first.each_with_index do |str, i|
      csv_answers.all? do |csv_answer|
        if i%2 == 0
          if csv_answer[i] == str
            # puts "."
            true
          else
            result << [str, i]
            puts "missing: #{str} at #{i}"
            false
          end
        else
          true
        end
      end
    end
    return result
  end
  
  def print_elems(first, second)
    first.each_with_index do |elem, i|
      puts "#{i}: #{elem} == #{second[i]}"
    end
  end
end