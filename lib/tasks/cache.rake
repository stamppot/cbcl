namespace :cache do
  desc 'Clear memcache'
  task :clear => :environment do
    Rails.cache.clear
  end
  
  desc "Flush memcached - this assumes memcached is on port 11211"
  task :flush do
  	run "echo 'flush_all' | nc localhost 11211 -w 3"
  end 
end

 