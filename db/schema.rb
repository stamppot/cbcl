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

ActiveRecord::Schema.define(:version => 20100815084726) do

  create_table "answer_cells", :force => true do |t|
    t.integer "answer_id",                :default => 0, :null => false
    t.string  "answertype", :limit => 20
    t.integer "col",                      :default => 0, :null => false
    t.integer "row",                      :default => 0, :null => false
    t.string  "item",       :limit => 5
    t.string  "value"
  end

  add_index "answer_cells", ["answer_id"], :name => "index_answer_cells_on_answer_id"

  create_table "answers", :force => true do |t|
    t.integer "survey_answer_id", :default => 0, :null => false
    t.integer "number",           :default => 0, :null => false
    t.integer "question_id",      :default => 0, :null => false
    t.integer "ratings_count"
  end

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
  end

  add_index "csv_answers", ["journal_id"], :name => "index_csv_answers_on_journal_id"
  add_index "csv_answers", ["survey_id"], :name => "index_csv_answers_on_survey_id"

  create_table "engine_schema_info", :id => false, :force => true do |t|
    t.string  "engine_name"
    t.integer "version"
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
    t.timestamp "created_at",                                  :null => false
    t.timestamp "updated_at",                                  :null => false
    t.string    "title",      :limit => 200, :default => "",   :null => false
    t.integer   "code"
    t.string    "type",       :limit => 16,  :default => "",   :null => false
    t.integer   "parent_id"
    t.integer   "center_id"
    t.boolean   "delta",                     :default => true, :null => false
  end

  add_index "groups", ["center_id"], :name => "groups_center_id_index"
  add_index "groups", ["center_id"], :name => "index_groups_on_center_id"
  add_index "groups", ["code"], :name => "index_groups_on_code"
  add_index "groups", ["delta"], :name => "index_groups_on_delta"
  add_index "groups", ["parent_id"], :name => "groups_parent_id_index"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.integer   "group_id",   :default => 0, :null => false
    t.integer   "role_id",    :default => 0, :null => false
    t.timestamp "created_at",                :null => false
  end

  add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
  add_index "groups_roles", ["role_id"], :name => "role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer   "group_id",   :default => 0, :null => false
    t.integer   "user_id",    :default => 0, :null => false
    t.timestamp "created_at",                :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "journal_entries", :force => true do |t|
    t.integer  "journal_id",       :default => 0, :null => false
    t.integer  "survey_id",        :default => 0, :null => false
    t.integer  "user_id"
    t.string   "password"
    t.integer  "survey_answer_id"
    t.datetime "created_at"
    t.datetime "answered_at"
    t.integer  "state",            :default => 0, :null => false
    t.datetime "updated_at"
  end

  add_index "journal_entries", ["journal_id"], :name => "index_journal_entries_on_journal_id"
  add_index "journal_entries", ["survey_answer_id"], :name => "index_journal_entries_on_survey_answer_id"
  add_index "journal_entries", ["survey_id"], :name => "index_journal_entries_on_survey_id"
  add_index "journal_entries", ["user_id"], :name => "index_journal_entries_on_user_id"

  create_table "letters", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.text     "letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nationalities", :force => true do |t|
    t.string "country",      :limit => 40
    t.string "country_code", :limit => 4
  end

  create_table "periods", :force => true do |t|
    t.integer  "subscription_id", :default => 0,     :null => false
    t.integer  "used",            :default => 0,     :null => false
    t.boolean  "paid",            :default => false
    t.date     "paid_on"
    t.date     "created_on"
    t.datetime "updated_on"
    t.boolean  "active",          :default => false, :null => false
  end

  add_index "periods", ["subscription_id"], :name => "index_periods_on_subscription_id"

  create_table "person_infos", :force => true do |t|
    t.integer "journal_id",  :default => 0,    :null => false
    t.string  "name",        :default => "",   :null => false
    t.integer "sex",         :default => 0,    :null => false
    t.date    "birthdate",                     :null => false
    t.string  "nationality", :default => "",   :null => false
    t.string  "cpr"
    t.boolean "delta",       :default => true, :null => false
  end

  add_index "person_infos", ["cpr"], :name => "index_person_infos_on_cpr"
  add_index "person_infos", ["delta"], :name => "index_person_infos_on_delta"
  add_index "person_infos", ["journal_id"], :name => "index_person_infos_on_journal_id"

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at"
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
    t.string    "identifier", :limit => 50,  :default => "", :null => false
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
    t.string    "title",      :limit => 100, :default => "", :null => false
    t.integer   "parent_id"
  end

  add_index "roles", ["parent_id"], :name => "roles_parent_id_index"

  create_table "roles_static_permissions", :id => false, :force => true do |t|
    t.integer   "role_id",              :default => 0, :null => false
    t.integer   "static_permission_id", :default => 0, :null => false
    t.timestamp "created_at",                          :null => false
  end

  add_index "roles_static_permissions", ["role_id"], :name => "role_id"
  add_index "roles_static_permissions", ["static_permission_id", "role_id"], :name => "roles_static_permissions_all_index", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer   "user_id",    :default => 0, :null => false
    t.integer   "role_id",    :default => 0, :null => false
    t.timestamp "created_at",                :null => false
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "score_groups", :force => true do |t|
    t.string "title"
    t.text   "description"
  end

  create_table "score_items", :force => true do |t|
    t.integer "score_id"
    t.integer "question_id"
    t.text    "items",       :limit => 255
    t.string  "range"
    t.integer "qualifier"
    t.integer "number"
  end

  add_index "score_items", ["score_id"], :name => "index_score_items_on_score_id"

  create_table "score_rapports", :force => true do |t|
    t.string   "title"
    t.string   "survey_name"
    t.string   "short_name"
    t.integer  "survey_id"
    t.integer  "survey_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unanswered"
    t.integer  "gender",                        :null => false
    t.string   "age_group",        :limit => 5, :null => false
    t.integer  "age"
    t.integer  "center_id"
  end

  create_table "score_refs", :force => true do |t|
    t.integer "score_id"
    t.integer "gender"
    t.string  "age_group"
    t.float   "mean"
    t.integer "percent95"
    t.integer "percent98"
  end

  add_index "score_refs", ["score_id"], :name => "index_score_refs_on_score_id"

  create_table "score_results", :force => true do |t|
    t.integer "score_rapport_id"
    t.integer "survey_id"
    t.integer "score_id"
    t.integer "result"
    t.integer "scale"
    t.string  "title"
    t.integer "position"
    t.float   "mean"
    t.boolean "deviation"
    t.boolean "percentile_98"
    t.boolean "percentile_95"
    t.integer "score_scale_id"
    t.integer "missing",            :default => 0
    t.float   "missing_percentage"
    t.integer "hits"
    t.boolean "valid_percentage"
  end

  add_index "score_results", ["score_id", "score_rapport_id"], :name => "index_score_results_on_score_id_and_score_rapport_id"
  add_index "score_results", ["score_id"], :name => "index_score_results_on_score_id"
  add_index "score_results", ["score_rapport_id"], :name => "index_score_results_on_score_rapport_id"

  create_table "score_scales", :force => true do |t|
    t.integer "position"
    t.string  "title"
  end

  create_table "scores", :force => true do |t|
    t.integer  "score_group_id"
    t.integer  "survey_id"
    t.string   "title"
    t.string   "short_name"
    t.integer  "sum"
    t.integer  "scale"
    t.integer  "position"
    t.integer  "score_scale_id"
    t.integer  "items_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores_surveys", :id => false, :force => true do |t|
    t.integer "score_id"
    t.integer "survey_id"
  end

  add_index "scores_surveys", ["score_id"], :name => "index_scores_surveys_on_score_id"
  add_index "scores_surveys", ["survey_id"], :name => "index_scores_surveys_on_survey_id"

  create_table "static_permissions", :force => true do |t|
    t.string    "identifier", :limit => 50,  :default => "", :null => false
    t.string    "title",      :limit => 200, :default => "", :null => false
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
  end

  add_index "static_permissions", ["title"], :name => "static_permissions_title_index", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.integer  "center_id",           :default => 0, :null => false
    t.integer  "survey_id",           :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",               :default => 0, :null => false
    t.text     "note"
    t.integer  "total_used"
    t.integer  "total_paid"
    t.integer  "active_used"
    t.date     "most_recent_payment"
  end

  add_index "subscriptions", ["center_id"], :name => "index_subscriptions_on_center_id"

  create_table "survey_answers", :force => true do |t|
    t.integer  "survey_id",                      :default => 0,     :null => false
    t.string   "surveytype",       :limit => 15
    t.string   "answered_by",      :limit => 15
    t.datetime "created_at"
    t.integer  "age",                            :default => 0,     :null => false
    t.integer  "sex",                            :default => 0,     :null => false
    t.string   "nationality",      :limit => 24
    t.integer  "journal_entry_id",               :default => 0,     :null => false
    t.boolean  "done",                           :default => false
    t.datetime "updated_at"
    t.integer  "journal_id"
    t.integer  "center_id"
  end

  add_index "survey_answers", ["journal_entry_id"], :name => "index_survey_answers_on_journal_entry_id"
  add_index "survey_answers", ["journal_id"], :name => "index_survey_answers_on_journal_id"
  add_index "survey_answers", ["survey_id"], :name => "index_survey_answers_on_survey_id"

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

  create_table "user_registrations", :force => true do |t|
    t.integer   "user_id",    :default => 0, :null => false
    t.text      "token",                     :null => false
    t.timestamp "created_at",                :null => false
    t.timestamp "expires_at",                :null => false
  end

  add_index "user_registrations", ["expires_at"], :name => "user_registrations_expires_at_index"
  add_index "user_registrations", ["user_id"], :name => "user_registrations_user_id_index", :unique => true

  create_table "users", :force => true do |t|
    t.timestamp "created_at",                                                   :null => false
    t.timestamp "updated_at",                                                   :null => false
    t.timestamp "last_logged_in_at",                                            :null => false
    t.integer   "login_failure_count",                :default => 0,            :null => false
    t.string    "login",               :limit => 100, :default => "",           :null => false
    t.string    "name",                :limit => 100, :default => "",           :null => false
    t.string    "email",               :limit => 200, :default => "",           :null => false
    t.string    "password",            :limit => 128, :default => "",           :null => false
    t.string    "password_hash_type",  :limit => 10,  :default => "",           :null => false
    t.string    "password_salt",       :limit => 100, :default => "1234512345", :null => false
    t.integer   "state",                              :default => 1,            :null => false
    t.integer   "center_id"
    t.boolean   "login_user",                         :default => false
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
  end

end
