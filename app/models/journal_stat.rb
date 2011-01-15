class JournalStat < ActiveRecord::Base
	
	def self.surveys_per_center_by_state
    results = JournalStat.connection.select_all("SELECT count(je.state) as count, je.survey_id, s.title as survey_title, je.state, j.center_id, g.title as center_title FROM groups j inner join journal_entries je ON je.journal_id = j.id inner join groups g ON g.id = j.center_id inner join surveys s ON je.survey_id = s.id group by g.title, s.title, je.state").group_by {|r| {"center_title" => r["center_title"], "center_id" => r["center_id"] } }
		
		stat = []
		results.each do |center,data| 
			stat << JournalStatePerCenter.new(center,data) 
		end
		stat
	end
end