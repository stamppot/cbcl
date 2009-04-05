class AddScoreCalculations < ActiveRecord::Migration
  def self.up
      # read the SQL script
    adapter = ActiveRecord::Base.configurations['development']['adapter']

    schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
    filename = File.join(schema_dir, "cbcl_scores.sql") #"create.#{adapter}.sql")
    
    raise "Could not find schema file #{filename}" unless File.exists?(filename)
    
    fcontent = IO.read(filename)
    
    # execute the SQL
    puts "Executing SQL script #{filename}"
    # execute SQL statements one by one since execute breaks with MySQL otherwise
    fcontent.split(';').each do |statement|
      execute statement unless statement.empty?
    end
    puts "Complete"
  end

  def self.down
    execute "DELETE FROM `scores`;"
  end
end
