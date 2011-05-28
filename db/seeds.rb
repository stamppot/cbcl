require 'lib/seed_helper'

puts "Seeding data..."

puts "Seeding users, groups, and roles"
SeedFromSql.insert_data("db/cbcl_users_groups.sql")

puts "Seeding surveys, questions, and question_cells"
SeedFromSql.insert_data("db/cbcl_surveys.sql")

puts "Seeding scores"
SeedFromSql.insert_data("db/cbcl_scores.sql")

puts "Seeding nationalities..."
nationalities = 
[['Dansk','DK'],
 ['Svensk','SVE'],
 ['Norsk','NOR'],
 ['Islandsk','ISL'],
 ['Tysk','DE'],
 ['Uoplyst',''],
 ['Adopteret',''],
 ['Indvandrer/flygtning',''],
 ['Andet','']]

nationalities.each do |arr|
  nationality = Nationality.find_by_country(arr.first)
  if !nationality
    Nationality.create(:country => arr.first, :country_code => arr.last)
  end
end

# unless ENV['RAILS_ENV'] == 'test'
#   Answer.all.each do |a|
#     a.ratings_count = a.answer_cells.ratings.not_answered.count
#     a.save
#     a.answer_cells = nil
#     a = nil
#   end
# end
