namespace :db do
  desc 'Add subscriptions to all centers
  Defaults to development database. Set RAILS_ENV to override.'

  task :add_subscriptions => :environment do
    surveys = Survey.all
    surveys.each do |survey|
      centers = Center.all
      centers.each do |center|
        sub = Subscription.new(:survey => survey, :center => center)
        sub.activate!
      end
    end
  end
  
end