require 'lib/seed_helper'

puts "Seeding data..."

puts "Seeding users, groups, and roles"
SeedHelper.insert_sql_data("db/cbcl_users_groups.sql")

puts "Seeding surveys, questions, and question_cells"
SeedHelper.insert_sql_data("db/cbcl_surveys.sql")

puts "Seeding scores"
SeedHelper.insert_sql_data("db/cbcl_scores.sql")

puts "Seeding nationalities..."
SeedHelper.insert_sql_data("db/cbcl_nationalities.sql")
