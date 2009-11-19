class Query
  
  attr_accessor :query, :select_clause, :from_where, :group_clause
  
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
  def join_clause(from_columns = nil, joins = nil)
    self.from_where = 
    if joins && from_columns
      joins = joins.to_h if joins.is_a? Array
      joins = joins.to_a
      clause = ["FROM #{from_columns.join(', ')}"] <<
              "WHERE #{joins.shift.join(' = ')} "
      joins.each {|a,b| clause << "AND #{a} = #{b}"}
      clause
    else
      ["FROM journal_entries, groups, survey_answers, person_infos ",
        "WHERE journal_entries.journal_id = groups.id AND groups.type = 'Journal' ",
        "AND journal_entries.survey_answer_id = survey_answers.id ",
        "AND journal_entries.journal_id = person_infos.journal_id "]
    end.join(' ')
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
     self.group_clause = ["GROUP BY #{column}"]
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
   
   def subscription_copies_for_center(center = nil, options = {})
     joins = ['subscriptions', 'copies']
     conditions = { 'subscriptions.id' => 'copies.subscription_id', 'subscriptions.state' => 1}
     conditions["copies.active"] = 1 if options["active"]
     conditions["copies.consolidated"] = 1 if options["paid"]
     if center
       conditions["subscriptions.center_id"] = center.is_a?(Center) && center.id || center
     else
       conditions['groups.type'] = "'Center'"
       conditions['subscriptions.center_id'] = 'groups.id'
       joins << 'groups'
     end

     self.select(["copies.id, subscriptions.center_id, subscriptions.total_used as total_used, subscriptions.active_used as active_used, survey_id, state, subscription_id, used, active, consolidated as paid, consolidated_on as paid_on, copies.created_on"])
     self.join_clause(joins, conditions)
     self.query = (self.select_clause << self.from_where).join(' ')
   end

   def query_subscription_copies_for_centers(center = nil, options = {})
     self.subscription_copies_for_center(center, options)
     self.do_query
   end

   # select surveys.title, copies.used, copies.subscription_id, used, sum(used) as total_used, (sum(used)-used) as active, created_on, consolidated_on, note, state
   # FROM subscriptions, copies, surveys
   # WHERE subscriptions.id = 1
   # AND subscriptions.survey_id = surveys.id
   # group by subscription_id;   
   def one_subscription_count(subscription)
     joins = ['subscriptions', 'copies', 'surveys']
     conditions = { 'subscriptions.survey_id' => 'surveys.id', 'subscriptions.id' => (subscription.is_a?(Subscription) && subscription.id || subscription) }
     self.select(["surveys.title, copies.subscription_id, survey_id, center_id, copies.used, sum(used) as total_used, (sum(used)-used) as active, created_on, consolidated_on, note, state"])
     self.join_clause(joins, conditions)
     self.query = (self.select_clause << self.from_where).join(' ')
   end

   # select subscriptions.center_id, surveys.title, copies.used, copies.subscription_id, used, sum(used) as total_used, (sum(used)-used) as active, created_on, consolidated_on, note, state
   # FROM subscriptions, copies, surveys
   # WHERE subscriptions.id = 1 
   # and subscriptions.survey_id = surveys.id
   # group by subscription_id;
   def all_subscription_counts
     joins = ['subscriptions', 'copies', 'surveys']
     conditions = { 'subscriptions.id' => 1, 'subscriptions.survey_id' => 'surveys.id' }
       self.select(["center_id, surveys.title, copies.used, copies.subscription_id, used, sum(used) as total_used, (sum(used)-used) as active, created_on, consolidated_on, note, state"])
     self.join_clause(joins, conditions)
     self.query = (self.select_clause << self.from_where << self.group_by('subscription_id')).join(' ')
   end

   def query_one_subscription_count(subscription = nil)
     self.all_subscription_counts(subscription)
     self.do_query
   end
   
   def query_all_subscription_counts
     self.all_subscription_counts
     self.do_query
   end
   
   # SELECT subscriptions.id as subscription_id, subscriptions.center_id, SUM(used)
   # FROM cbcl_production.subscriptions, cbcl_production.copies
   # where subscriptions.id = copies.subscription_id
   # and subscriptions.center_id = 1
   # group by subscriptions.id
   def subscriptions_count(center = nil)
     joins = ['subscriptions', 'copies']
     conditions = { 'subscriptions.id' => 'copies.subscription_id' }
     if center && center.is_a?(Center)
       conditions["subscriptions.center_id"] = center.is_a?(Center) && center.id || center
     end
     if center.is_a? Subscription
       conditions["subscriptions.id"] = center.id
     end
     self.select(["subscriptions.center_id, survey_id, subscriptions.id as subscription_id, SUM(used) as sum, created_on, consolidated_on, note, state"])
     self.join_clause(joins, conditions)
     self.query = (self.select_clause << self.from_where << self.group_by('subscriptions.id')).join(' ')
   end
   
   def query_subscriptions_count(center = nil)
     self.subscriptions_count(center)
     self.do_query
   end
   
   # SELECT subscriptions.center_id, subscriptions.id, SUM(used) FROM cbcl_production.subscriptions, cbcl_production.copies
   #where subscriptions.id = copies.subscription_id
   #group by subscriptions.id
   def copies_count(subscription = nil)
     joins = ['subscriptions', 'copies']
     conditions = { 'subscriptions.id' => 'copies.subscription_id' }
     if subscription
       conditions["subscriptions.id"] = subscription.is_a?(Subscription) && subscription.id || subscription
     end
     
     self.select(["subscriptions.center_id, survey_id, subscriptions.id as subscription_id, SUM(used) as sum, note, state"])
     self.join_clause(joins, conditions)
     self.query = (self.select_clause << self.from_where << self.group_by('subscriptions.id')).join(' ')     
   end
   
   def query_journal_to_survey_answers(surveys, entries, startdate = 100.years.ago, stopdate = Time.now.utc, age_low = 1, age_high = 21)
     do_query(journal_to_survey_answers(surveys, entries, startdate, stopdate, age_low, age_high)).build_hash { |elem| [elem["journal_id"], elem["survey_answer_id"]] }
   end

   def user_journal_entries(entries, surveys, startdate = 100.years.ago, stopdate = Time.now.utc, age_low = 1, age_high = 21)
      self.query = self.select(["survey_answers.journal_entry_id"]).join << 
          (self.small_join_clause << date_filter("survey_answers", startdate, stopdate) << done_filter << 
           age_filter(age_low, age_high) << survey_filter(surveys) << filter_entries(entries) << group_by("survey_answer_id")).join
   end

   def do_query(query = nil, to_hash = false)
     mysql_result = ActiveRecord::Base.connection.execute(query || self.query).all_hashes
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