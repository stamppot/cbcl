class SeedHelper < ActiveRecord::Migration

  def self.insert_sql_data(filename, show_output = true)
    if filename.blank?
      puts "No file given as argument"
      return
    end

    # read the SQL script
    adapter = ActiveRecord::Base.configurations['development']['adapter']

    schema_dir = Pathname.new(__FILE__).dirname.realpath.parent.to_s
    filename = File.join(schema_dir, filename) #"create.#{adapter}.sql")

    raise "Could not find schema file #{filename}" unless File.exists?(filename)

    fcontent = IO.read(filename)

    # execute the SQL
    puts "Executing SQL script #{filename}"
    # execute SQL statements one by one since execute breaks with MySQL otherwise
    fcontent.split(';').each do |statement|
      if statement =~ /^(INSERT|ALTER|BEGIN|END)/
        # puts statement if show_output && !statement.blank?
        execute statement.strip if statement && !statement.blank?
      # elsif statement && !statement.blank?
      #   ;
      # elsif  statement.strip.empty? || statement == "\n" || statement == "\n\n" || statement[0] == "/"
      else
        puts "Skipping statement" unless show_output
      end
    end
    puts "Completed inserting #{filename}"
  end
end