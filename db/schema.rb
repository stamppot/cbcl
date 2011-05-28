# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 15) do

# Could not dump table "answer_cells" because of following ArgumentError
#   struct size differs

# Could not dump table "answers" because of following ArgumentError
#   struct size differs

# Could not dump table "center_infos" because of following ArgumentError
#   struct size differs

  create_table "center_settings", :force => true do |t|
    t.integer  "center_id"
    t.string   "settings"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "csv_answers" because of following ArgumentError
#   struct size differs

  create_table "export_files", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faq_sections", :force => true do |t|
    t.string  "title"
    t.integer "position"
  end

# Could not dump table "faqs" because of following ArgumentError
#   struct size differs

# Could not dump table "groups" because of following ArgumentError
#   struct size differs

# Could not dump table "groups_roles" because of following ArgumentError
#   struct size differs

# Could not dump table "groups_users" because of following ArgumentError
#   struct size differs

# Could not dump table "journal_entries" because of following ArgumentError
#   struct size differs

# Could not dump table "letters" because of following ArgumentError
#   struct size differs

  create_table "nationalities", :force => true do |t|
    t.string "country",      :limit => 40
    t.string "country_code", :limit => 4
  end

# Could not dump table "periods" because of following ArgumentError
#   struct size differs

# Could not dump table "person_infos" because of following ArgumentError
#   struct size differs

# Could not dump table "question_cells" because of following ArgumentError
#   struct size differs

# Could not dump table "questions" because of following ArgumentError
#   struct size differs

# Could not dump table "roles" because of following ArgumentError
#   struct size differs

# Could not dump table "roles_users" because of following ArgumentError
#   struct size differs

  create_table "score_groups", :force => true do |t|
    t.string "title"
    t.text   "description"
  end

# Could not dump table "score_items" because of following ArgumentError
#   struct size differs

# Could not dump table "score_rapports" because of following ArgumentError
#   struct size differs

# Could not dump table "score_refs" because of following ArgumentError
#   struct size differs

# Could not dump table "score_results" because of following ArgumentError
#   struct size differs

  create_table "score_scales", :force => true do |t|
    t.integer "position"
    t.string  "title"
  end

# Could not dump table "scores" because of following ArgumentError
#   struct size differs

# Could not dump table "scores_surveys" because of following ArgumentError
#   struct size differs

# Could not dump table "subscriptions" because of following ArgumentError
#   struct size differs

# Could not dump table "survey_answers" because of following ArgumentError
#   struct size differs

  create_table "surveys", :force => true do |t|
    t.string  "title",       :limit => 40
    t.string  "category"
    t.text    "description"
    t.string  "age"
    t.string  "surveytype",  :limit => 15
    t.string  "color",       :limit => 7
    t.integer "position",                  :default => 99
  end

  create_table "tasks", :force => true do |t|
    t.string   "status"
    t.integer  "export_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "users" because of following ArgumentError
#   struct size differs

# Could not dump table "variables" because of following ArgumentError
#   struct size differs

end
