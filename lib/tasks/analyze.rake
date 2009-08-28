namespace :analyze do
  desc 'Analyze a log file and produce a performance report.'

  desc 'Analyze production log'
  task :production => :environment do
    run "cd #{current_path}; request-log-analyzer log/production.log"
  end
  
  task :development do
    run "cd #{current_path}; request-log-analyzer log/development.log"
  end
end
