class JournalStatePerCenter
  
  attr_accessor :surveys, :center_id, :center_title
  
  def initialize(center, data)
    @center_title = center["center_title"]
    @center_id = center["center_id"].to_i
		# puts "DAATA: #{data.inspect}"
		tmp = data.group_by {|s| s["survey_title"]}
		# puts "TMP: #{tmp.inspect}"
    @surveys = tmp.map {|k,v| StatePerSurvey.new(k,v)}
  end
end

class StatePerSurvey

  attr_accessor :count, :survey_id, :survey_title, :center_id, :center_title, :states #, :by_login_user, :by_personnel, :unanswered, :draft

  def initialize(survey, data)
		# puts "STATEPERSURVEY: #{survey.inspect} data: #{data.inspect}"
		# puts "data: #{data.inspect}"
    @survey_title = survey
		@states = data.map {|d| CountPerState.new(d["count"], d["state"])}
  end
  
end

class CountPerState
  
  attr_accessor :count, :state
  
  def initialize(count, state)
    # puts "COUNTPERSTATE: #{count} #{JournalEntry.states.invert[state.to_i]}"
    @count = count.to_i
    @state = state.to_i
  end
end