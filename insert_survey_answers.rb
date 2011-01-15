#  !/usr/bin/env ruby

class InsertSurveyAnswers
  
  # loads filtered log files, containing only parameters for survey_answer/create and inserts a survey_answer for each line
  def load_file(filename)
    params = []
    File.open(filename) do |file|
      file.each_line { |line| params << eval(line.gsub("Parameters: ", "").strip) }
    end
    params
  end

  def load_save_all_survey_answers(filename)
    save_all_survey_answers(load_file(filename))
  end
  
  def save_all_survey_answers(arr)
    all_answers = []
    arr.each { |params| all_answers << save_survey_answer(params) }
    return all_answers
  end
  
  def save_survey_answer(params)
    journal_entry = JournalEntry.find(params['id'])
    survey = journal_entry.survey
    
    if journal_entry.survey_answer.nil?
      journal = journal_entry.journal
      journal_entry.survey_answer = SurveyAnswer.create(:survey => survey, :age => journal.age, :sex => journal.sex_text, 
            :surveytype => survey.surveytype, :nationality => journal.nationality, :journal_entry => journal_entry)
      puts "Created survey_answer: #{journal_entry.survey_answer.inspect}"
    end
    survey_answer = journal_entry.survey_answer
    puts "Saved survey_answer for journal #{params['id']}"
    survey_answer.done = true
    survey_answer.save_final(params)
    return survey_answer
  rescue
    puts "id: #{params['id']}   params: #{params.inspect}"
  end
  
  def load_all_files
    answers = []
    basedir = "/Users/jens/Desktop/backup_logs"
    Dir.chdir(basedir)
    Dir.foreach(".") do |file|
      # puts "file: #{file}"
      if file =~ /^production/
        puts "\nGot #{file}"
        answers = load_save_all_survey_answers(basedir + "/" + file)
      end
    end
    answers.each do |survey_answer|
      puts "Generating CSVAnswer for SurveyAnswer #{survey_answer.id}"
      survey_answer.create_csv_answer!
    end
  end
end


class FindMissingJournals
  
  def find_entries
    start = "2009-12-09 23:59:59".to_datetime
    stop = "2009-11-28 00:00:00".to_datetime
    je = JournalEntry.find(:all, :conditions =>['answered_at < ? and answered_at > ?', start, stop])
    totals = je.sort_by {|e| e.journal.center_id}.map {|e| s = e.survey;  "journal_id: #{e.journal_id}, navn: #{e.journal.title}, link_id: #{e.id}, skema: #{s.title[0..14]}, center: #{e.journal.center.title}"}
  
    # per center
    ce = je.map {|e| e.journal.center.title }
    counts = ce.inject(Hash.new(0)) {|memo, value| memo[value]+=1; memo}.sort {|a,b| -1*(a[1]<=>b[1]) }
    p counts
    counts
  end
    
end
