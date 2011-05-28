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

  create_table "answer_cells", :force => true do |t|
    t.integer "answer_id",               :default => 0, :null => false
    t.integer "col",                     :default => 0, :null => false
    t.integer "row",                     :default => 0, :null => false
    t.string  "item",       :limit => 5
    t.boolean "rating"
    t.string  "value_text"
    t.boolean "text"
    t.integer "cell_type"
    t.integer "value"
  end

  add_index "answer_cells", ["answer_id"], :name => "index_answer_cells_on_answer_id"
  add_index "answer_cells", ["row"], :name => "index_answer_cells_on_row"

  create_table "answers", :force => true do |t|
    t.integer "survey_answer_id", :null => false
    t.integer "number",           :null => false
    t.integer "question_id",      :null => false
    t.integer "ratings_count"
  end

  add_index "answers", ["number"], :name => "index_answers_on_number"
  add_index "answers", ["survey_answer_id"], :name => "index_answers_on_survey_answer_id"

  create_table "center_infos", :force => true do |t|
    t.integer "center_id"
    t.string  "street"
    t.string  "zipcode"
    t.string  "city"
    t.string  "telephone"
    t.string  "ean"
    t.string  "person"
  end

  create_table "center_settings", :force => true do |t|
    t.integer  "center_id"
    t.string   "settings"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "copies", :force => true do |t|
    t.integer  "subscription_id", :default => 0,     :null => false
    t.integer  "used",            :default => 0,     :null => false
    t.boolean  "consolidated",    :default => false
    t.date     "consolidated_on"
    t.date     "created_on"
    t.datetime "updated_on"
    t.boolean  "active",          :default => false, :null => false
  end

  create_table "csv_answers", :force => true do |t|
    t.integer "survey_answer_id"
    t.integer "survey_id"
    t.integer "journal_entry_id"
    t.integer "journal_id"
    t.integer "age"
    t.integer "sex"
    t.text    "answer"
    t.string  "header"
    t.string  "journal_info"
  end

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

  create_table "faqs", :force => true do |t|
    t.integer "faq_section_id"
    t.integer "position"
    t.string  "question"
    t.string  "answer"
    t.string  "title"
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "title",      :limit => 200, :default => "",   :null => false
    t.integer  "code"
    t.string   "type",       :limit => 16,  :default => "",   :null => false
    t.integer  "parent_id"
    t.integer  "center_id"
    t.boolean  "delta",                     :default => true, :null => false
  end

  add_index "groups", ["center_id"], :name => "index_groups_on_center_id"
  add_index "groups", ["code"], :name => "index_groups_on_code"
  add_index "groups", ["delta"], :name => "index_groups_on_delta"
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["type"], :name => "index_groups_on_type"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.integer  "group_id",   :default => 0, :null => false
    t.integer  "role_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
  add_index "groups_roles", ["role_id"], :name => "role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id",   :default => 0, :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "journal_entries", :force => true do |t|
    t.integer  "journal_id",       :null => false
    t.integer  "survey_id",        :null => false
    t.integer  "user_id"
    t.string   "password"
    t.integer  "survey_answer_id"
    t.datetime "created_at"
    t.datetime "answered_at"
    t.integer  "state",            :null => false
  end

  create_table "letters", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.text     "letter"
    t.string   "surveytype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nationalities", :force => true do |t|
    t.string "country",      :limit => 40
    t.string "country_code", :limit => 4
  end

  create_table "periods", :force => true do |t|
    t.integer  "subscription_id",                    :null => false
    t.integer  "used",            :default => 0,     :null => false
    t.boolean  "paid",            :default => false
    t.date     "paid_on"
    t.date     "created_on"
    t.datetime "updated_on"
    t.boolean  "active",          :default => false, :null => false
  end

  create_table "person_infos", :force => true do |t|
    t.integer  "journal_id",                    :null => false
    t.string   "name",                          :null => false
    t.integer  "sex",                           :null => false
    t.date     "birthdate",                     :null => false
    t.string   "nationality",                   :null => false
    t.string   "cpr"
    t.boolean  "delta",       :default => true, :null => false
    t.datetime "updated_at"
  end

  create_table "question_cells", :force => true do |t|
    t.integer "question_id",               :null => false
    t.string  "type",        :limit => 20
    t.integer "col"
    t.integer "row"
    t.string  "answer_item", :limit => 5
    t.text    "items"
    t.string  "preferences"
    t.string  "var"
  end

  create_table "questions", :force => true do |t|
    t.integer "survey_id",     :null => false
    t.integer "number",        :null => false
    t.integer "ratings_count"
  end

  create_table "roles", :force => true do |t|
    t.string   "identifier", :limit => 50,  :default => "", :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "title",      :limit => 100, :default => "", :null => false
    t.integer  "parent_id"
  end

  add_index "roles", ["parent_id"], :name => "roles_parent_id_index"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.integer  "role_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true

  create_table "score_groups", :force => true do |t|
    t.string "title"
    t.text   "description"
  end

  create_table "score_items", :force => true do |t|
    t.integer "score_id"
    t.integer "question_id"
    t.text    "items"
    t.string  "range"
    t.integer "qualifier"
    t.integer "number"
  end

  create_table "score_rapports", :force => true do |t|
    t.string   "title"
    t.string   "survey_name"
    t.string   "short_name"
    t.integer  "survey_id"
    t.integer  "survey_answer_id"
    t.integer  "unanswered"
    t.integer  "gender",                        :null => false
    t.string   "age_group",        :limit => 5, :null => false
    t.integer  "age"
    t.integer  "center_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "score_refs", :force => true do |t|
    t.integer "score_id"
    t.integer "gender"
    t.string  "age_group"
    t.float   "mean"
    t.integer "percent95"
    t.integer "percent98"
  end

  create_table "score_results", :force => true do |t|
    t.integer "score_rapport_id"
    t.integer "survey_id"
    t.integer "score_id"
    t.integer "result"
    t.string  "percentile"
    t.integer "scale"
    t.string  "title"
    t.integer "position"
    t.integer "score_scale_id"
    t.integer "missing",            :default => 0
    t.float   "missing_percentage"
    t.integer "hits"
    t.boolean "valid_percentage"
    t.float   "mean"
    t.boolean "deviation"
    t.boolean "percentile_98"
    t.boolean "percentile_95"
  end

  create_table "score_scales", :force => true do |t|
    t.integer "position"
    t.string  "title"
  end

  create_table "scores", :force => true do |t|
    t.integer  "score_group_id"
    t.integer  "survey_id",      :null => false
    t.string   "title",          :null => false
    t.string   "short_name",     :null => false
    t.integer  "sum",            :null => false
    t.integer  "scale"
    t.integer  "position"
    t.integer  "score_scale_id"
    t.integer  "items_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scores", ["score_scale_id"], :name => "index_scores_on_score_scale_id"
  add_index "scores", ["survey_id"], :name => "index_scores_on_survey_id"

  create_table "scores_surveys", :id => false, :force => true do |t|
    t.integer "score_id"
    t.integer "survey_id"
  end

  add_index "scores_surveys", ["score_id"], :name => "index_scores_surveys_on_score_id"
  add_index "scores_surveys", ["survey_id"], :name => "index_scores_surveys_on_survey_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "center_id",           :null => false
    t.integer  "survey_id",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",               :null => false
    t.text     "note"
    t.integer  "total_used"
    t.integer  "total_paid"
    t.integer  "active_used"
    t.date     "most_recent_payment"
  end

  create_table "survey_answers", :force => true do |t|
    t.integer "survey_id",                                          :null => false
    t.string  "surveytype",       :limit => 15
    t.string  "answered_by",      :limit => 100
    t.integer "age",                                                :null => false
    t.integer "sex",                                                :null => false
    t.string  "nationality",      :limit => 40
    t.integer "journal_entry_id",                                   :null => false
    t.boolean "done",                            :default => false
    t.integer "journal_id"
    t.integer "center_id"
  end

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

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.datetime "last_logged_in_at",                                            :null => false
    t.integer  "login_failure_count",                :default => 0,            :null => false
    t.string   "login",               :limit => 100, :default => "",           :null => false
    t.string   "name",                :limit => 100, :default => "",           :null => false
    t.string   "email",               :limit => 200, :default => "",           :null => false
    t.string   "password",            :limit => 128, :default => "",           :null => false
    t.string   "password_hash_type",  :limit => 10,  :default => "",           :null => false
    t.string   "password_salt",       :limit => 100, :default => "1234512345", :null => false
    t.integer  "state",                              :default => 1,            :null => false
    t.integer  "center_id"
    t.boolean  "login_user",                         :default => false
    t.integer  "delta"
  end

  add_index "users", ["center_id"], :name => "users_center_id_index"
  add_index "users", ["login"], :name => "users_login_index", :unique => true
  add_index "users", ["password"], :name => "users_password_index"

  create_table "variables", :force => true do |t|
    t.string   "var"
    t.string   "item"
    t.integer  "row"
    t.integer  "col"
    t.integer  "survey_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "datatype"
  end

end
