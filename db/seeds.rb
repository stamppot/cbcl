require 'lib/seed_helper'

puts "Seeding data..."

puts "Seeding users, groups, and roles"
SeedFromSql.insert_data("db/cbcl_users_groups.sql")

puts "Seeding surveys, questions, and question_cells"
SeedFromSql.insert_data("db/cbcl_surveys.sql")

puts "Seeding scores"
SeedFromSql.insert_data("db/cbcl_scores.sql")

puts "Seeding nationalities..."
SeedFromSql.insert_data("db/cbcl_nationalities.sql")
