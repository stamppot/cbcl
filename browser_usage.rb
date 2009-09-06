class BrowserUsage < RequestLogAnalyzer::FileFormat::Rails
  
  line_definition :current_user do |line|
    line.regexp = /LOGIN ([A-z-]+\s\d+)/
    line.captures << { :name => :user, :type => :string }
  end
  
  line_definition :current_browser do |line|
    line.regexp = /LOGIN (.+): (\.+)/
    line.captures << { :name => :user, :type => :string } \
                  << { :name => :browser, :type => :string }
  end
  
  # Append the default Rails report with some frequency tables
  report(:append) do |analyze|
    analyze.frequency :user, :title => "User", :line_type => :current_users
    analyze.frequency :current_browser, :title => "Browser types", :line_type => :current_browser
  end
end