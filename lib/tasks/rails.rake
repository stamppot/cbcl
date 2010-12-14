desc "Checks your app and gently warns you if you are using deprecated code." 
task :deprecated => :environment do
  deprecated = {
    '@params'    => 'Use params[] instead',
    '@session'   => 'Use session[] instead',
    '@flash'     => 'Use flash[] instead',
    '@request'   => 'Use request[] instead',
    '@env' => 'Use env[] instead',
    'find_all'   => 'Use find(:all) instead',
    'find_first' => 'Use find(:first) instead',
    'render_partial' => 'Use render :partial instead',
    'component'  => 'Use of components are frowned upon',
    ' paginate'   => 'The default paginator is slow. Writing your own may be faster',
    'start_form_tag'   => 'Use form_for instead',
    'end_form_tag'   => 'Use form_for instead',
    ':post => true'   => 'Use :method => :post instead'
  }

  deprecated.each do |key, warning|
    puts '--> ' + key
    output = `cd '#{File.expand_path('app', RAILS_ROOT)}' && grep -n --exclude=*.svn* -r '#{key}' *`
    unless output =~ /^$/
      puts "  !! " + warning + " !!" 
      puts '  ' + '.' * (warning.length + 6)
      puts output
    else
      puts "  Clean! Cheers for you!" 
    end
    puts
  end
end

require 'find'#
require 'ftools'
namespace :db do
  desc "Backup the user data tables from database to a file. Options: DIR=base_dir RAILS_ENV=production MAX=20" 
  task :backup_cbcl => :environment do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")    
    tables = %w{answer_cells answers survey_answers copies groups groups_roles groups_users journal_entries person_infos roles roles_users score_groups score_items score_rapports score_refs score_results scores subscriptions users}.join(" ")
    base_path = ENV["DIR"] || "db" 
    backup_base = File.join(base_path, 'backup')
    backup_folder = File.join(backup_base, datestamp)
    backup_file = File.join(backup_folder, "#{RAILS_ENV}_dump.sql.gz")   
    FileUtils.mkdir_p(backup_folder)
    db_config = ActiveRecord::Base.configurations[RAILS_ENV]
    pass = ''
    pass = '-p' + db_config['password'] if db_config['password'] #  -Q —add-drop-table -O add-locks=FALSE -O lock-tables=FALSE
    sh "mysqldump -u #{db_config['username']} #{pass} #{db_config['database']} | gzip -c > #{backup_file}"     
    dir = Dir.new(backup_base)
    all_backups = dir.entries[2..-1].sort.reverse
    puts "Created backup: #{backup_file}" 
    max_backups = (ENV["MAX"] || 20).to_i
    puts max_backups
    unwanted_backups = all_backups[max_backups..-1] || []
    for unwanted_backup in unwanted_backups
      FileUtils.rm_rf(File.join(backup_base, unwanted_backup))
      puts "deleted #{unwanted_backup}" 
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available" 
  end
end

namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure"
  end
  task :index, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart"
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure"
  end
  task :in, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart"
  end
end

############### memcached recipes ##########
namespace :memcached do 
	desc "Start memcached"
	task :start, :roles => [:app], :only => {:memcached => true} do
		sudo "/etc/init.d/memcached start"
	end
	desc "Stop memcached"
	task :stop, :roles => [:app], :only => {:memcached => true} do
		sudo "/etc/init.d/memcached stop"
	end
	desc "Restart memcached"
	task :restart, :roles => [:app], :only => {:memcached => true} do
		sudo "/etc/init.d/memcached restart"
	end        
	desc "Flush memcached - this assumes memcached is on port 11211"
	task :flush, :roles => [:app], :only => {:memcached => true} do
		sudo "echo 'flush_all' | nc localhost 11211"
	end        
	desc "Symlink the memcached.yml file into place if it exists"
	task :symlink_configs, :roles => [:app], :only => {:memcached => true }, :except => { :no_release => true } do
		run "if [ -f #{shared_path}/config/memcached.yml ]; then ln -nfs #{shared_path}/config/memcached.yml #{latest_release}/config/memcached.yml; fi"
	end
end

