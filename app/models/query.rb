class Query
  
  attr_accessor :query, :select_clause
  
  def select(args)
    if args.blank?
      self.select_clause = select_all
    else
      self.select_clause = ["select #{args.join(", ")} "]
    end
  end
  
  def select_all
    ["select journal_entry_id, journal_entries.journal_id, journal_entries.survey_id, journal_entries.survey_answer_id, person_infos.birthdate "]
  end

  def small_join_clause
    ["FROM journal_entries, survey_answers ",
    "WHERE journal_entries.survey_answer_id = survey_answers.id "]
  end  
  
  # TODO: join arrays/hashes - {"journal_entries.journal_id" => "groups.id" }
  def join_clause
    ["FROM journal_entries, groups, survey_answers, person_infos ",
    "WHERE journal_entries.journal_id = groups.id AND groups.type = 'Journal' ",
    "AND journal_entries.survey_answer_id = survey_answers.id ",
    "AND journal_entries.journal_id = person_infos.journal_id "]
  end

  # @journal_survey_answers ||= ["select journal_entry_id, journal_entries.journal_id, journal_entries.survey_id, journal_entries.survey_answer_id, person_infos.birthdate",
  # "from journal_entries, groups, survey_answers, person_infos",
  # "where journal_entries.journal_id = groups.id AND groups.type = 'Journal'",
  # "and journal_entries.survey_answer_id = survey_answers.id",
  # "and journal_entries.journal_id = person_infos.journal_id "].join(' ')
  
  def date_filter(tablecolumn = "survey_answers", startdate = 100.years.ago, enddate = Time.now.utc)
    dates = filter_date(startdate, enddate)
    ["AND #{tablecolumn}.created_at BETWEEN '#{dates[:start_date]}' AND '#{dates[:stop_date]}' "]
  end
  
  def age_filter(age_low = 1, age_hi = 21)
    ["AND survey_answers.age BETWEEN #{age_low} AND #{age_hi} "]
   end
   
   def done_filter
     ["AND (done = 1) "]
   end
   
   def survey_filter(surveys, table = "journal_entries")
     ["AND #{table}.survey_id IN (#{surveys.join(',')}) "]
   end
   
   def group_by(column)
     ["GROUP BY #{column}"]
   end
   
   def filter_entries(entry_ids, tablecolumn = "survey_answers.journal_entry_id")
     ["AND #{tablecolumn} IN (#{entry_ids.join(', ')}) "]
   end
   
   def journal_to_survey_answers(surveys, entries = [], startdate = 100.years.ago, stopdate = Time.now.utc, age_low = 1, age_high = 21)
     survey = Survey.all.map {|s| s.id} if surveys.empty?
     entries = entries.blank? ? [] : filter_entries(entries)
     self.query = self.select(["journal_entries.survey_answer_id, journal_entries.journal_id"]).join << 
        (self.join_clause << date_filter("survey_answers", startdate, stopdate) << done_filter << 
         age_filter(age_low, age_high) << survey_filter(surveys) << entries << group_by("survey_answer_id")).join
   end
   
   # protected

   def query_journal_to_survey_answers(surveys, entries, startdate = 100.years.ago, stopdate = Time.now.utc, age_low = 1, age_high = 21)
     do_query(journal_to_survey_answers(surveys, entries, startdate, stopdate, age_low, age_high)).build_hash { |elem| [elem["journal_id"], elem["survey_answer_id"]] }
   end

   def user_journal_entries(entries, surveys, startdate = 100.years.ago, stopdate = Time.now.utc, age_low = 1, age_high = 21)
      self.query = self.select(["survey_answers.journal_entry_id"]).join << 
          (self.small_join_clause << date_filter("survey_answers", startdate, stopdate) << done_filter << 
           age_filter(age_low, age_high) << survey_filter(surveys) << filter_entries(entries) << group_by("survey_answer_id")).join
   end

   def do_query(query, to_hash = false)
      mysql_result = ActiveRecord::Base.connection.execute(query).all_hashes
   end
   
   def filter_date(start, stop)
     args = {}
     if start.is_a?(Time) and stop.is_a?(Time)
       args[:start_date] = start
       args[:stop_date] = stop
     elsif start.is_a?(Date) and stop.is_a?(Date)
       args[:start_date] = start.to_time
       args[:stop_date] = stop.to_time
     else
       {:start_date => start, :stop_date => stop}.each_pair do |key, date|
         unless date.blank?
           y = date[:year].to_i
           m = date[:month].to_i
           d = date[:day].to_i
           args[key] = Date.new(y, m, d).to_time
         end
       end
     end
     args[:start_date] = args[:start_date].to_s(:db)
     args[:stop_date] = args[:stop_date].to_s(:db)
     return args
   end

   def filter_age(args)
     args[:age_start] ||= 1
     args[:age_stop] ||= 21

     if args[:age] && (start_age = args[:age][:start].to_i) && (stop_age = args[:age][:stop].to_i)
       if start_age <= stop_age
         args[:age_start] = start_age
         args[:age_stop] = stop_age
       else
         args[:age_start] = stop_age
         args[:age_stop] = start_age
       end
     end
     return args
   end 
end