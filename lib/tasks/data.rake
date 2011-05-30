namespace :data do
  desc 'Add subscriptions to all centers
  Defaults to development database. Set RAILS_ENV to override.'

  task :add_subscriptions => :environment do
    surveys = Survey.all
    surveys.each do |survey|
      centers = Center.all
      centers.each do |center|
        if(center.subscriptions.blank?)
          sub = Subscription.new(:survey => survey, :center => center)
          sub.activate!
        end
      end
    end
  end

  task :survey_answers_update_center_and_journal => :environment do
    puts "Add survey_answer updated timestamp and add center to survey_answer"
    SurveyAnswer.find_each do |sa|
      if !sa.center_id || (sa.journal_entry || !sa.journal_id)
        sa.center_id = sa.journal.center_id
        if sa.journal_entry || !sa.journal_id
          sa.journal_id = sa.journal_entry.journal_id
        end
        sa.save
      end

      # cleanup survey_answers without a journal_entry
      sa.destroy if !sa.journal_entry && sa.answers.empty? && sa.answers.empty? 
    end
  end
  
  task :update_ratings_count => :environment do
    puts "updating ratings_count for Questions"
    Question.all.each do |q|
      q.ratings_count = q.ratings.size
      q.save
    end

    puts "updating ratings_count for Answers"
    unless ENV['RAILS_ENV'] == 'test'
      Answer.all.each do |a|
        a.ratings_count = a.answer_cells.ratings.not_answered.count
        a.save
        a.answer_cells = nil
        a = nil
      end
    end
  end
  
  task :add_score_scale => :environment do
    puts "Add score_scale_id and update it from ScoreResults"
    ScoreResult.all.each do |result|
      result.score_scale_id = result.score.score_scale_id
      result.save
    end
  end

  task :update_subscriptions => :environment do
    puts "Updating subscriptions with total_used, total_paid, most_recent_payment and active_used"
    subs = Subscription.all(:include => :periods)
    subs.each do |sub|
      sub.total_used = sub.periods_used
      last_paid = sub.periods.reverse.detect(&:paid_on)
      sub.total_paid = sub.periods.paid.sum(:used)
      sub.most_recent_payment = last_paid.paid_on if last_paid
      sub.active_used = sub.unpaid_used
      sub.save
    end
  end
  
  task :update_variables => :environment do
    puts "Update/create variable datatype.. survey.get_variables"
    Survey.all.each do |survey|
      vars = survey.get_variables
      vars.values.each {|v| puts "item: #{v.item} datatype: #{v.datatype}"}
      vars.values.each {| v| v.save}
    end
  end
  
  task :generate_csv_answers => :environment do
    puts "Generating CSV answers from survey_answers. Can take a while..."
    CSVHelper.new.generate_csv_answers
  end
  
  desc "Seed fixed data: surveys, roles, scores, nationalities"
  task :seed_fixed_data => :environment do
    require 'lib/seed_helper'
    puts "Seeding fixed data: surveys, roles, scores, nationalities"
    puts "Seeding users, groups, and roles"
    SeedFromSql.insert_data("db/cbcl_users_groups.sql")

    puts "Seeding surveys, questions, and question_cells"
    SeedFromSql.insert_data("db/cbcl_surveys.sql")

    puts "Seeding scores"
    SeedFromSql.insert_data("db/cbcl_scores.sql")

    puts "Seeding nationalities..."
    SeedFromSql.insert_data("db/cbcl_nationalities.sql")
  end
  
  desc "Insert data from SQL file. Only INSERT/ALTER are executed"
  task :seed_dynamic_data, :filename, :needs => :environment do |t, args|
    require 'lib/seed_helper'
    puts "Seeding user-created data: fx survey_answers, users, groups, subscriptions etc"
    puts "Argument is: #{args}"
    puts "No filename given: #{args}" if args.empty?
    SeedFromSql.insert_data(args[:filename])
  end
  
  desc "Update question_cells with variable name and datatype"
  task :question_cells_add_variable_datatype => :environment do
    puts "Adding variable name and datatype to question_cells"
    vars = Variable.all
    vars.each do |var|
      puts "Fetching question_cell question_id: #{var.question_id} row: #{var.row} col: #{var.col} item: #{var.item}"
      qc = QuestionCell.find_by_question_id_and_row_and_col(var.question_id, var.row, var.col)
      qc.var = var.var
      qc.datatype = var.datatype
      qc.save
    end
  end
end