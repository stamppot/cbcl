class MoveJournalsToOwnTable
  def self.up
    run_sql = true
    commands = []
    sql = "Select * from groups where groups.type = 'Journal'"
    records = ActiveRecord::Base.connection.execute(sql)
    records.each do |r|
        id = r[0]
        created_at = r[1]
        updated_at = r[2]
        title = r[3]
        code = r[4]
        t = r[5] # type: Journal
        parent_id = r[6]
        center_id = r[7]
        delta = r[8]
    	sql = %{REPLACE INTO journals (id, created_at, updated_at, title, code, group_id, center_id, delta) 
    		VALUES (#{id}, '#{created_at}', '#{updated_at}', "#{title}", '#{code}', #{parent_id}, #{center_id}, 0)
    	}
    	puts sql
    	ActiveRecord::Base.connection.execute(sql) if run_sql
    	commands << sql
    end

   	ActiveRecord::Base.connection.execute("update journals set group_id = center_id where team_id IS NULL") if run_sql

    Journal.delete_all if run_sql
    puts commands.join("; ")
  end
end

class MyTest
    def test
        sql = "Select * from groups where groups.type = 'Journal'"
        records = ActiveRecord::Base.connection.execute(sql)
        records.each do |r|
            id = r[0]
            created_at = r[1]
            updated_at = r[2]
            title = r[3]
            code = r[4]
            t = r[5] # type: Journal
            parent_id = r[6]
            center_id = r[7]
            delta = r[8]
            puts r.inspect
        end
    end
end