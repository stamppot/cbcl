desc "export the database models to YML fixtures"
task(:models_to_fixtures => :environment) do
  ActiveRecord::Base.establish_connection(
   :adapter => 'mysql',
   :encoding => 'utf8',
   :database => 'cbcl_production',
   :username => 'jens',
   :password => 'hestehund'
  )
  ActiveRecord::Base.connection
  
  if ENV['MODELS'].nil? || ENV['MODELS'].blank?
    raise "Please enter valid models names separated by coma. Ex: MODELS=User,Account"
  end
  
  models = ENV['MODELS'].split(',').collect { |arg| arg.camelize.constantize }
  
  models.each do |model|
    output = {}
    collection = model.find(:all)
    collection.each do |object|
      output.store(object.to_param, object.attributes)
    end
    file_path = "#{RAILS_ROOT}/tmp/#{model.table_name}.yml" # /tmp/
    File.open(file_path, "w+") { |file| file.write(output.to_yaml) }
  end
end
