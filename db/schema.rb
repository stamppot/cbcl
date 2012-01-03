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

ActiveRecord::Schema.define(:version => 20110105182159) do

  create_table "answer_cells", :force => true do |t|
    t.integer "answer_id",                  :default => 0, :null => false
    t.integer "col",                        :default => 0, :null => false
    t.integer "row",                        :default => 0, :null => false
    t.string  "item",       :limit => 5
    t.boolean "rating"
    t.string  "value_text", :limit => 2200
    t.boolean "text"
    t.integer "cell_type"
    t.integer "value"
  end

  add_index "answer_cells", ["answer_id"], :name => "index_answer_cells_on_answer_id"

  create_table "answers", :force => true do |t|
    t.integer "survey_answer_id", :default => 0, :null => false
    t.integer "number",           :default => 0, :null => false
    t.integer "question_id",      :default => 0, :null => false
    t.integer "ratings_count"
  end

  add_index "answers", ["question_id"], :name => "fk_answers_questions"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
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

  add_index "center_infos", ["center_id"], :name => "index_center_infos_on_center_id"

  create_table "center_settings", :force => true do |t|
    t.integer  "center_id"
    t.string   "settings"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "code_books", :force => true do |t|
    t.integer "survey_id",   :null => false
    t.string  "title",       :null => false
    t.string  "description"
  end

  create_table "codes", :force => true do |t|
    t.integer "code_book_id",      :null => false
    t.integer "question_id",       :null => false
    t.integer "question_number",   :null => false
    t.string  "variable",          :null => false
    t.string  "item_type",         :null => false
    t.string  "item",              :null => false
    t.string  "datatype",          :null => false
    t.string  "description"
    t.string  "measurement_level"
    t.integer "row",               :null => false
    t.integer "col",               :null => false
    t.integer "item_choice_id",    :null => false
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

  add_index "csv_answers", ["journal_id"], :name => "index_csv_answers_on_journal_id"
  add_index "csv_answers", ["survey_id"], :name => "index_csv_answers_on_survey_id"

  create_table "csv_survey_answers", :force => true do |t|
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.integer "survey_id"
    t.integer "journal_entry_id"
    t.integer "age"
    t.integer "sex"
    t.text    "answer"
    t.string  "header"
    t.string  "journal_info"
  end

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

  create_table "export_journal_infos", :force => true do |t|
    t.integer "journal_id",        :limit => 3
    t.string  "ssghafd",           :limit => 40
    t.string  "ssghnavn",          :limit => 40
    t.string  "safdnavn",          :limit => 40
    t.string  "pid",               :limit => 12
    t.integer "pkoen",             :limit => 1
    t.integer "palder",            :limit => 1
    t.integer "pkoen_datatype"
    t.integer "palder_datatype"
    t.string  "pnation",           :limit => 30
    t.integer "pnation_datatype",  :limit => 1
    t.date    "dagsdato"
    t.date    "pfoedt"
    t.integer "dagsdato_datatype", :limit => 1
    t.integer "pfoedt_datatype",   :limit => 1
  end

  add_index "export_journal_infos", ["journal_id"], :name => "index_export_journal_infos_on_journal_id"

  create_table "export_variables_cc_answers", :force => true do |t|
    t.integer "export_journal_info_id"
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.integer "cc1",                    :limit => 1
    t.integer "cc2",                    :limit => 1
    t.integer "cc3",                    :limit => 1
    t.integer "cc4",                    :limit => 1
    t.integer "cc5",                    :limit => 1
    t.integer "cc6",                    :limit => 1
    t.integer "cc7",                    :limit => 1
    t.integer "cc8",                    :limit => 1
    t.integer "cc9",                    :limit => 1
    t.integer "cc10",                   :limit => 1
    t.integer "cc11",                   :limit => 1
    t.integer "cc12",                   :limit => 1
    t.integer "cc13",                   :limit => 1
    t.integer "cc14",                   :limit => 1
    t.integer "cc15",                   :limit => 1
    t.integer "cc16",                   :limit => 1
    t.integer "cc17",                   :limit => 1
    t.integer "cc18",                   :limit => 1
    t.integer "cc19",                   :limit => 1
    t.integer "cc20",                   :limit => 1
    t.integer "cc21",                   :limit => 1
    t.integer "cc22",                   :limit => 1
    t.integer "cc23",                   :limit => 1
    t.integer "cc24",                   :limit => 1
    t.string  "cc24hv"
    t.integer "cc25",                   :limit => 1
    t.integer "cc26",                   :limit => 1
    t.integer "cc27",                   :limit => 1
    t.integer "cc28",                   :limit => 1
    t.integer "cc29",                   :limit => 1
    t.integer "cc30",                   :limit => 1
    t.integer "cc31",                   :limit => 1
    t.string  "cc31hv"
    t.integer "cc32",                   :limit => 1
    t.string  "cc32hv"
    t.integer "cc33",                   :limit => 1
    t.integer "cc34",                   :limit => 1
    t.integer "cc35",                   :limit => 1
    t.integer "cc36",                   :limit => 1
    t.integer "cc37",                   :limit => 1
    t.integer "cc38",                   :limit => 1
    t.integer "cc39",                   :limit => 1
    t.integer "cc40",                   :limit => 1
    t.integer "cc41",                   :limit => 1
    t.integer "cc42",                   :limit => 1
    t.integer "cc43",                   :limit => 1
    t.integer "cc44",                   :limit => 1
    t.integer "cc45",                   :limit => 1
    t.integer "cc46",                   :limit => 1
    t.string  "cc46hv"
    t.integer "cc47",                   :limit => 1
    t.integer "cc48",                   :limit => 1
    t.integer "cc49",                   :limit => 1
    t.integer "cc50",                   :limit => 1
    t.integer "cc51",                   :limit => 1
    t.integer "cc52",                   :limit => 1
    t.integer "cc53",                   :limit => 1
    t.integer "cc54",                   :limit => 1
    t.string  "cc54hv"
    t.integer "cc55",                   :limit => 1
    t.integer "cc56",                   :limit => 1
    t.integer "cc57",                   :limit => 1
    t.integer "cc58",                   :limit => 1
    t.integer "cc59",                   :limit => 1
    t.integer "cc60",                   :limit => 1
    t.integer "cc61",                   :limit => 1
    t.integer "cc62",                   :limit => 1
    t.integer "cc63",                   :limit => 1
    t.integer "cc64",                   :limit => 1
    t.integer "cc65",                   :limit => 1
    t.integer "cc66",                   :limit => 1
    t.integer "cc67",                   :limit => 1
    t.integer "cc68",                   :limit => 1
    t.integer "cc69",                   :limit => 1
    t.integer "cc70",                   :limit => 1
    t.integer "cc71",                   :limit => 1
    t.integer "cc72",                   :limit => 1
    t.integer "cc73",                   :limit => 1
    t.integer "cc74",                   :limit => 1
    t.string  "cc74hv"
    t.integer "cc75",                   :limit => 1
    t.integer "cc76",                   :limit => 1
    t.string  "cc76hv"
    t.integer "cc77",                   :limit => 1
    t.integer "cc78",                   :limit => 1
    t.integer "cc79",                   :limit => 1
    t.integer "cc80",                   :limit => 1
    t.string  "cc80hv"
    t.integer "cc81",                   :limit => 1
    t.integer "cc82",                   :limit => 1
    t.integer "cc83",                   :limit => 1
    t.integer "cc84",                   :limit => 1
    t.integer "cc85",                   :limit => 1
    t.integer "cc86",                   :limit => 1
    t.integer "cc87",                   :limit => 1
    t.integer "cc88",                   :limit => 1
    t.integer "cc89",                   :limit => 1
    t.integer "cc90",                   :limit => 1
    t.integer "cc91",                   :limit => 1
    t.integer "cc92",                   :limit => 1
    t.string  "cc92hv"
    t.integer "cc93",                   :limit => 1
    t.integer "cc94",                   :limit => 1
    t.integer "cc95",                   :limit => 1
    t.integer "cc96",                   :limit => 1
    t.integer "cc97",                   :limit => 1
    t.integer "cc98",                   :limit => 1
    t.integer "cc99",                   :limit => 1
    t.integer "cc100",                  :limit => 1
    t.string  "cc100hv"
    t.integer "cchandic",               :limit => 1
    t.integer "cchandhv",               :limit => 1
    t.string  "ccbekyhv"
    t.string  "ccbedshv"
    t.integer "ccfodtid",               :limit => 1
    t.integer "ccfodg",                 :limit => 1
    t.integer "ccorebet",               :limit => 1
    t.integer "ccsproan",               :limit => 1
    t.string  "ccsprohv"
    t.integer "cctale",                 :limit => 1
    t.integer "cctalehv",               :limit => 1
    t.integer "ccsprobe",               :limit => 1
    t.string  "ccsprobehv"
    t.string  "ccudvian"
    t.integer "ccfoduge",               :limit => 1
  end

  add_index "export_variables_cc_answers", ["journal_id"], :name => "index_export_variables_cc_answers_on_journal_id"

  create_table "export_variables_ccy_answers", :force => true do |t|
    t.integer "export_journal_info_id"
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.integer "ccyispor",               :limit => 1
    t.integer "ccyiaspg",               :limit => 1
    t.integer "ccyibspg",               :limit => 1
    t.integer "ccyicspg",               :limit => 1
    t.integer "ccyiihob",               :limit => 1
    t.integer "ccyiiahg",               :limit => 1
    t.integer "ccyiibhg",               :limit => 1
    t.integer "ccyiichg",               :limit => 1
    t.integer "ccyiiifo",               :limit => 1
    t.integer "ccyiiia",                :limit => 1
    t.integer "ccyiiib",                :limit => 1
    t.integer "ccyiiic",                :limit => 1
    t.integer "ccyivjob",               :limit => 1
    t.integer "ccyivjag",               :limit => 1
    t.integer "ccyivjbg",               :limit => 1
    t.integer "ccyivjcg",               :limit => 1
    t.integer "ccyv1ven",               :limit => 1
    t.integer "ccyv2vea",               :limit => 1
    t.integer "ccyvisos",               :limit => 1
    t.integer "ccyvibor",               :limit => 1
    t.integer "ccyvifor",               :limit => 1
    t.integer "ccyviale",               :limit => 1
    t.integer "ccyviisko",              :limit => 1
    t.string  "ccyviiund"
    t.integer "caviilae",               :limit => 1
    t.integer "caviista",               :limit => 1
    t.integer "caviimat",               :limit => 1
    t.integer "caviinat",               :limit => 1
    t.integer "caviieng",               :limit => 1
    t.integer "caviivu1",               :limit => 1
    t.integer "caviivu2",               :limit => 1
    t.integer "ctcundty",               :limit => 1
    t.integer "ctcgomkl",               :limit => 1
    t.string  "ctcgomhv"
    t.integer "ccyvii4pr",              :limit => 1
    t.string  "ccyvii4hv"
    t.integer "ccyvii4ho",              :limit => 1
    t.integer "ccyhandi",               :limit => 1
    t.string  "ccyhandhv"
    t.string  "ccyviii2hv"
    t.string  "ccyviii3hv"
    t.integer "ccy1",                   :limit => 1
    t.integer "ccy2",                   :limit => 1
    t.string  "ccy2hv"
    t.integer "ccy3",                   :limit => 1
    t.integer "ccy4",                   :limit => 1
    t.integer "ccy5",                   :limit => 1
    t.integer "ccy6",                   :limit => 1
    t.integer "ccy7",                   :limit => 1
    t.integer "ccy8",                   :limit => 1
    t.integer "ccy9",                   :limit => 1
    t.string  "ccy9hv"
    t.integer "ccy10",                  :limit => 1
    t.integer "ccy11",                  :limit => 1
    t.integer "ccy12",                  :limit => 1
    t.integer "ccy13",                  :limit => 1
    t.integer "ccy14",                  :limit => 1
    t.integer "ccy15",                  :limit => 1
    t.integer "ccy16",                  :limit => 1
    t.integer "ccy17",                  :limit => 1
    t.integer "ccy18",                  :limit => 1
    t.integer "ccy19",                  :limit => 1
    t.integer "ccy20",                  :limit => 1
    t.integer "ccy21",                  :limit => 1
    t.integer "ccy22",                  :limit => 1
    t.integer "ccy23",                  :limit => 1
    t.integer "ccy24",                  :limit => 1
    t.integer "ccy25",                  :limit => 1
    t.integer "ccy26",                  :limit => 1
    t.integer "ccy27",                  :limit => 1
    t.integer "ccy28",                  :limit => 1
    t.integer "ccy29",                  :limit => 1
    t.string  "ccy29hv"
    t.integer "ccy30",                  :limit => 1
    t.integer "ccy31",                  :limit => 1
    t.integer "ccy32",                  :limit => 1
    t.integer "ccy33",                  :limit => 1
    t.integer "ccy34",                  :limit => 1
    t.integer "ccy35",                  :limit => 1
    t.integer "ccy36",                  :limit => 1
    t.integer "ccy37",                  :limit => 1
    t.integer "ccy38",                  :limit => 1
    t.integer "ccy39",                  :limit => 1
    t.integer "ccy40",                  :limit => 1
    t.string  "ccy40hv"
    t.integer "ccy41",                  :limit => 1
    t.integer "ccy42",                  :limit => 1
    t.integer "ccy43",                  :limit => 1
    t.integer "ccy44",                  :limit => 1
    t.integer "ccy45",                  :limit => 1
    t.integer "ccy46",                  :limit => 1
    t.string  "ccy46hv"
    t.integer "ccy47",                  :limit => 1
    t.integer "ccy48",                  :limit => 1
    t.integer "ccy49",                  :limit => 1
    t.integer "ccy50",                  :limit => 1
    t.integer "ccy51",                  :limit => 1
    t.integer "ccy52",                  :limit => 1
    t.integer "ccy53",                  :limit => 1
    t.integer "ccy54",                  :limit => 1
    t.integer "ccy55",                  :limit => 1
    t.integer "ccy56a",                 :limit => 1
    t.integer "ccy56b",                 :limit => 1
    t.integer "ccy56c",                 :limit => 1
    t.integer "ccy56d",                 :limit => 1
    t.string  "ccy56dhv"
    t.integer "ccy56e",                 :limit => 1
    t.integer "ccy56f",                 :limit => 1
    t.integer "ccy56g",                 :limit => 1
    t.integer "ccy56h",                 :limit => 1
    t.string  "ccy56hhv"
    t.integer "ccy57",                  :limit => 1
    t.integer "ccy58",                  :limit => 1
    t.string  "ccy58hv"
    t.integer "ccy59",                  :limit => 1
    t.integer "ccy60",                  :limit => 1
    t.integer "ccy61",                  :limit => 1
    t.integer "ccy62",                  :limit => 1
    t.integer "ccy63",                  :limit => 1
    t.integer "ccy64",                  :limit => 1
    t.integer "ccy65",                  :limit => 1
    t.integer "ccy66",                  :limit => 1
    t.string  "ccy66hv"
    t.integer "ccy67",                  :limit => 1
    t.integer "ccy68",                  :limit => 1
    t.integer "ccy69",                  :limit => 1
    t.integer "ccy70",                  :limit => 1
    t.string  "ccy70hv"
    t.integer "ccy71",                  :limit => 1
    t.integer "ccy72",                  :limit => 1
    t.integer "ccy73",                  :limit => 1
    t.string  "ccy73hv"
    t.integer "ccy74",                  :limit => 1
    t.integer "ccy75",                  :limit => 1
    t.integer "ccy76",                  :limit => 1
    t.integer "ccy77",                  :limit => 1
    t.string  "ccy77hv"
    t.integer "ccy78",                  :limit => 1
    t.integer "ccy79",                  :limit => 1
    t.string  "ccy79hv"
    t.integer "ccy80",                  :limit => 1
    t.integer "ccy81",                  :limit => 1
    t.integer "ccy82",                  :limit => 1
    t.integer "ccy83",                  :limit => 1
    t.string  "ccy83hv"
    t.integer "ccy84",                  :limit => 1
    t.string  "ccy84hv"
    t.integer "ccy85",                  :limit => 1
    t.string  "ccy85hv"
    t.integer "ccy86",                  :limit => 1
    t.integer "ccy87",                  :limit => 1
    t.integer "ccy88",                  :limit => 1
    t.integer "ccy89",                  :limit => 1
    t.integer "ccy90",                  :limit => 1
    t.integer "ccy91",                  :limit => 1
    t.integer "ccy92",                  :limit => 1
    t.string  "ccy92hv"
    t.integer "ccy93",                  :limit => 1
    t.integer "ccy94",                  :limit => 1
    t.integer "ccy95",                  :limit => 1
    t.integer "ccy96",                  :limit => 1
    t.integer "ccy97",                  :limit => 1
    t.integer "ccy98",                  :limit => 1
    t.integer "ccy99",                  :limit => 1
    t.integer "ccy100",                 :limit => 1
    t.string  "ccy100hv"
    t.integer "ccy101",                 :limit => 1
    t.integer "ccy102",                 :limit => 1
    t.integer "ccy103",                 :limit => 1
    t.integer "ccy104",                 :limit => 1
    t.integer "ccy105",                 :limit => 1
    t.string  "ccy105hv"
    t.integer "ccy106",                 :limit => 1
    t.integer "ccy107",                 :limit => 1
    t.integer "ccy108",                 :limit => 1
    t.integer "ccy109",                 :limit => 1
    t.integer "ccy110",                 :limit => 1
    t.integer "ccy111",                 :limit => 1
    t.integer "ccy112",                 :limit => 1
    t.string  "ccy113hv"
    t.integer "ccyiaspt",               :limit => 1
    t.integer "ccyibspt",               :limit => 1
    t.integer "ccyicspt",               :limit => 1
    t.integer "ccyiasp",                :limit => 1
    t.integer "ccyibsp",                :limit => 1
    t.integer "ccyicsp",                :limit => 1
    t.integer "ccyiiah",                :limit => 1
    t.integer "ccyiiaht",               :limit => 1
    t.integer "ccyiibh",                :limit => 1
    t.integer "ccyiich",                :limit => 1
    t.integer "ccyiibht",               :limit => 1
    t.integer "ccyiicht",               :limit => 1
    t.integer "ccyiiiaa",               :limit => 1
    t.integer "ccyiiiba",               :limit => 1
    t.integer "ccyiiica",               :limit => 1
    t.integer "ccyivja",                :limit => 1
    t.integer "ccyivjb",                :limit => 1
    t.integer "ccyivjc",                :limit => 1
    t.integer "caviian1",               :limit => 1
    t.integer "caviian2",               :limit => 1
    t.integer "ctcunder",               :limit => 1
    t.integer "ctcgaaom",               :limit => 1
  end

  add_index "export_variables_ccy_answers", ["journal_id"], :name => "index_export_variables_ccy_answers_on_journal_id"

  create_table "export_variables_ct_answers", :force => true do |t|
    t.integer "export_journal_info_id"
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.string  "ctinst"
    t.integer "ctpasty",                :limit => 1
    t.integer "ctpashv",                :limit => 1
    t.integer "ctborn",                 :limit => 1
    t.integer "cttimer",                :limit => 1
    t.integer "ctkentid",               :limit => 1
    t.integer "cttraen",                :limit => 1
    t.integer "cttraehv",               :limit => 1
    t.integer "ct1",                    :limit => 1
    t.integer "ct2",                    :limit => 1
    t.integer "ct3",                    :limit => 1
    t.integer "ct4",                    :limit => 1
    t.integer "ct5",                    :limit => 1
    t.integer "ct6",                    :limit => 1
    t.integer "ct7",                    :limit => 1
    t.integer "ct8",                    :limit => 1
    t.integer "ct9",                    :limit => 1
    t.integer "ct10",                   :limit => 1
    t.integer "ct11",                   :limit => 1
    t.integer "ct12",                   :limit => 1
    t.integer "ct13",                   :limit => 1
    t.integer "ct14",                   :limit => 1
    t.integer "ct15",                   :limit => 1
    t.integer "ct16",                   :limit => 1
    t.integer "ct17",                   :limit => 1
    t.integer "ct18",                   :limit => 1
    t.integer "ct19",                   :limit => 1
    t.integer "ct20",                   :limit => 1
    t.integer "ct21",                   :limit => 1
    t.integer "ct22",                   :limit => 1
    t.integer "ct23",                   :limit => 1
    t.integer "ct24",                   :limit => 1
    t.integer "ct25",                   :limit => 1
    t.integer "ct26",                   :limit => 1
    t.integer "ct27",                   :limit => 1
    t.integer "ct28",                   :limit => 1
    t.integer "ct29",                   :limit => 1
    t.integer "ct30",                   :limit => 1
    t.integer "ct31",                   :limit => 1
    t.string  "ct31hv"
    t.integer "ct32",                   :limit => 1
    t.string  "ct32hv"
    t.integer "ct33",                   :limit => 1
    t.integer "ct34",                   :limit => 1
    t.integer "ct35",                   :limit => 1
    t.integer "ct36",                   :limit => 1
    t.integer "ct37",                   :limit => 1
    t.integer "ct38",                   :limit => 1
    t.integer "ct39",                   :limit => 1
    t.integer "ct40",                   :limit => 1
    t.integer "ct41",                   :limit => 1
    t.integer "ct42",                   :limit => 1
    t.integer "ct43",                   :limit => 1
    t.integer "ct44",                   :limit => 1
    t.integer "ct45",                   :limit => 1
    t.integer "ct46",                   :limit => 1
    t.string  "ct46hv"
    t.integer "ct47",                   :limit => 1
    t.integer "ct48",                   :limit => 1
    t.integer "ct49",                   :limit => 1
    t.integer "ct50",                   :limit => 1
    t.integer "ct51",                   :limit => 1
    t.integer "ct52",                   :limit => 1
    t.integer "ct53",                   :limit => 1
    t.integer "ct54",                   :limit => 1
    t.string  "ct54hv"
    t.integer "ct55",                   :limit => 1
    t.integer "ct56",                   :limit => 1
    t.integer "ct57",                   :limit => 1
    t.integer "ct58",                   :limit => 1
    t.integer "ct59",                   :limit => 1
    t.integer "ct60",                   :limit => 1
    t.integer "ct61",                   :limit => 1
    t.integer "ct62",                   :limit => 1
    t.integer "ct63",                   :limit => 1
    t.integer "ct64",                   :limit => 1
    t.integer "ct65",                   :limit => 1
    t.integer "ct66",                   :limit => 1
    t.integer "ct67",                   :limit => 1
    t.integer "ct68",                   :limit => 1
    t.integer "ct69",                   :limit => 1
    t.integer "ct70",                   :limit => 1
    t.integer "ct71",                   :limit => 1
    t.integer "ct72",                   :limit => 1
    t.integer "ct73",                   :limit => 1
    t.integer "ct74",                   :limit => 1
    t.integer "ct75",                   :limit => 1
    t.integer "ct76",                   :limit => 1
    t.string  "ct76hv"
    t.integer "ct77",                   :limit => 1
    t.integer "ct78",                   :limit => 1
    t.integer "ct79",                   :limit => 1
    t.integer "ct80",                   :limit => 1
    t.string  "ct80hv"
    t.integer "ct81",                   :limit => 1
    t.integer "ct82",                   :limit => 1
    t.integer "ct83",                   :limit => 1
    t.integer "ct84",                   :limit => 1
    t.integer "ct85",                   :limit => 1
    t.integer "ct86",                   :limit => 1
    t.integer "ct87",                   :limit => 1
    t.integer "ct88",                   :limit => 1
    t.integer "ct89",                   :limit => 1
    t.integer "ct90",                   :limit => 1
    t.integer "ct91",                   :limit => 1
    t.integer "ct92",                   :limit => 1
    t.string  "ct92hv"
    t.integer "ct93",                   :limit => 1
    t.integer "ct94",                   :limit => 1
    t.integer "ct95",                   :limit => 1
    t.integer "ct96",                   :limit => 1
    t.integer "ct97",                   :limit => 1
    t.integer "ct98",                   :limit => 1
    t.integer "ct99",                   :limit => 1
    t.integer "ct100",                  :limit => 1
    t.string  "ct100hv"
    t.integer "cthandic",               :limit => 1
    t.string  "cthandhv"
    t.string  "ctbekyhv"
    t.string  "ctbedshv"
    t.string  "ctkendla"
  end

  add_index "export_variables_ct_answers", ["journal_id"], :name => "index_export_variables_ct_answers_on_journal_id"

  create_table "export_variables_tt_answers", :force => true do |t|
    t.integer "export_journal_info_id"
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.integer "ttkltrin",               :limit => 1
    t.string  "ttskolen"
    t.integer "ttiikend",               :limit => 1
    t.string  "ttlekt"
    t.string  "ttv"
    t.integer "ttcgomkl",               :limit => 1
    t.integer "ttcgomhv",               :limit => 1
    t.integer "taviivu2",               :limit => 1
    t.integer "taviian1",               :limit => 1
    t.integer "taviian2",               :limit => 1
    t.integer "ttviiihu",               :limit => 1
    t.string  "ttixhandhv"
    t.integer "ttxbekym",               :limit => 1
    t.integer "ttxibedsthv",            :limit => 1
    t.integer "tt1",                    :limit => 1
    t.integer "tt2",                    :limit => 1
    t.integer "tt3",                    :limit => 1
    t.integer "tt4",                    :limit => 1
    t.integer "tt5",                    :limit => 1
    t.integer "tt6",                    :limit => 1
    t.integer "tt7",                    :limit => 1
    t.integer "tt8",                    :limit => 1
    t.integer "tt9",                    :limit => 1
    t.string  "tt9hv"
    t.integer "tt10",                   :limit => 1
    t.integer "tt11",                   :limit => 1
    t.integer "tt12",                   :limit => 1
    t.integer "tt13",                   :limit => 1
    t.integer "tt14",                   :limit => 1
    t.integer "tt15",                   :limit => 1
    t.integer "tt16",                   :limit => 1
    t.integer "tt17",                   :limit => 1
    t.integer "tt18",                   :limit => 1
    t.integer "tt19",                   :limit => 1
    t.integer "tt20",                   :limit => 1
    t.integer "tt21",                   :limit => 1
    t.integer "tt22",                   :limit => 1
    t.integer "tt23",                   :limit => 1
    t.integer "tt24",                   :limit => 1
    t.integer "tt25",                   :limit => 1
    t.integer "tt26",                   :limit => 1
    t.integer "tt27",                   :limit => 1
    t.integer "tt28",                   :limit => 1
    t.integer "tt29",                   :limit => 1
    t.string  "tt29hv"
    t.integer "tt30",                   :limit => 1
    t.integer "tt31",                   :limit => 1
    t.integer "tt32",                   :limit => 1
    t.integer "tt33",                   :limit => 1
    t.integer "tt34",                   :limit => 1
    t.integer "tt35",                   :limit => 1
    t.integer "tt36",                   :limit => 1
    t.integer "tt37",                   :limit => 1
    t.integer "tt38",                   :limit => 1
    t.integer "tt39",                   :limit => 1
    t.integer "tt40",                   :limit => 1
    t.string  "tt40hv"
    t.integer "tt41",                   :limit => 1
    t.integer "tt42",                   :limit => 1
    t.integer "tt43",                   :limit => 1
    t.integer "tt44",                   :limit => 1
    t.integer "tt45",                   :limit => 1
    t.integer "tt46",                   :limit => 1
    t.string  "tt46hv"
    t.integer "tt47",                   :limit => 1
    t.integer "tt48",                   :limit => 1
    t.integer "tt49",                   :limit => 1
    t.integer "tt50",                   :limit => 1
    t.integer "tt51",                   :limit => 1
    t.integer "tt52",                   :limit => 1
    t.integer "tt53",                   :limit => 1
    t.integer "tt54",                   :limit => 1
    t.integer "tt55",                   :limit => 1
    t.integer "tt56a",                  :limit => 1
    t.integer "tt56b",                  :limit => 1
    t.integer "tt56c",                  :limit => 1
    t.integer "tt56d",                  :limit => 1
    t.string  "tt56dhv"
    t.integer "tt56e",                  :limit => 1
    t.integer "tt56f",                  :limit => 1
    t.integer "tt56g",                  :limit => 1
    t.integer "tt56h",                  :limit => 1
    t.string  "tt56hhv"
    t.integer "tt57",                   :limit => 1
    t.integer "tt58",                   :limit => 1
    t.string  "tt58hv"
    t.integer "tt59",                   :limit => 1
    t.integer "tt60",                   :limit => 1
    t.integer "tt61",                   :limit => 1
    t.integer "tt62",                   :limit => 1
    t.integer "tt63",                   :limit => 1
    t.integer "tt64",                   :limit => 1
    t.integer "tt65",                   :limit => 1
    t.integer "tt66",                   :limit => 1
    t.string  "tt66hv"
    t.integer "tt67",                   :limit => 1
    t.integer "tt68",                   :limit => 1
    t.integer "tt69",                   :limit => 1
    t.integer "tt70",                   :limit => 1
    t.string  "tt70hv"
    t.integer "tt71",                   :limit => 1
    t.integer "tt72",                   :limit => 1
    t.integer "tt73",                   :limit => 1
    t.string  "tt73hv"
    t.integer "tt74",                   :limit => 1
    t.integer "tt75",                   :limit => 1
    t.integer "tt76",                   :limit => 1
    t.integer "tt77",                   :limit => 1
    t.integer "tt78",                   :limit => 1
    t.integer "tt79",                   :limit => 1
    t.string  "tt79hv"
    t.integer "tt80",                   :limit => 1
    t.integer "tt81",                   :limit => 1
    t.integer "tt82",                   :limit => 1
    t.integer "tt83",                   :limit => 1
    t.string  "tt83hv"
    t.integer "tt84",                   :limit => 1
    t.string  "tt84hv"
    t.integer "tt85",                   :limit => 1
    t.string  "tt85hv"
    t.integer "tt86",                   :limit => 1
    t.integer "tt87",                   :limit => 1
    t.integer "tt88",                   :limit => 1
    t.integer "tt89",                   :limit => 1
    t.integer "tt90",                   :limit => 1
    t.integer "tt91",                   :limit => 1
    t.integer "tt92",                   :limit => 1
    t.integer "tt93",                   :limit => 1
    t.integer "tt94",                   :limit => 1
    t.integer "tt95",                   :limit => 1
    t.integer "tt96",                   :limit => 1
    t.integer "tt97",                   :limit => 1
    t.integer "tt98",                   :limit => 1
    t.integer "tt99",                   :limit => 1
    t.integer "tt100",                  :limit => 1
    t.integer "tt101",                  :limit => 1
    t.integer "tt102",                  :limit => 1
    t.integer "tt103",                  :limit => 1
    t.integer "tt104",                  :limit => 1
    t.integer "tt105",                  :limit => 1
    t.string  "tt105hv"
    t.integer "tt106",                  :limit => 1
    t.integer "tt107",                  :limit => 1
    t.integer "tt108",                  :limit => 1
    t.integer "tt109",                  :limit => 1
    t.integer "tt110",                  :limit => 1
    t.integer "tt111",                  :limit => 1
    t.integer "tt112",                  :limit => 1
    t.string  "tt113hv"
    t.integer "ttkent",                 :limit => 1
    t.string  "ttfag"
    t.integer "ttcunder",               :limit => 1
    t.integer "ttcundty",               :limit => 1
    t.integer "ttcgaaom",               :limit => 1
    t.integer "taviivu1",               :limit => 1
    t.integer "taviilae",               :limit => 1
    t.integer "taviista",               :limit => 1
    t.integer "taviimat",               :limit => 1
    t.integer "taviinat",               :limit => 1
    t.integer "taviieng",               :limit => 1
    t.integer "ttviiiar",               :limit => 1
    t.integer "ttviiiop",               :limit => 1
    t.integer "ttviiila",               :limit => 1
  end

  add_index "export_variables_tt_answers", ["journal_id"], :name => "index_export_variables_tt_answers_on_journal_id"

  create_table "export_variables_ycy_answers", :force => true do |t|
    t.integer "export_journal_info_id"
    t.integer "journal_id"
    t.integer "survey_answer_id"
    t.integer "ycyiaspg",               :limit => 1
    t.integer "ycyibspg",               :limit => 1
    t.integer "ycyicspg",               :limit => 1
    t.integer "ycyiihob",               :limit => 1
    t.integer "ycyiiahg",               :limit => 1
    t.integer "ycyiibhg",               :limit => 1
    t.integer "ycyiichg",               :limit => 1
    t.integer "ycyiiifo",               :limit => 1
    t.integer "ycyiiiaa",               :limit => 1
    t.integer "ycyiiiba",               :limit => 1
    t.integer "ycyiiica",               :limit => 1
    t.integer "ycyivjob",               :limit => 1
    t.integer "ycyivjag",               :limit => 1
    t.integer "ycyivjbg",               :limit => 1
    t.integer "ycyivjcg",               :limit => 1
    t.integer "ycyv1ven",               :limit => 1
    t.integer "ycyv2vea",               :limit => 1
    t.integer "ycyvisos",               :limit => 1
    t.integer "ycyvibor",               :limit => 1
    t.integer "ycyvifor",               :limit => 1
    t.integer "ycyviale",               :limit => 1
    t.integer "yaviilae",               :limit => 1
    t.integer "yaviista",               :limit => 1
    t.integer "yaviimat",               :limit => 1
    t.integer "yaviinat",               :limit => 1
    t.integer "yaviieng",               :limit => 1
    t.integer "yaviivu1",               :limit => 1
    t.integer "yaviivu2",               :limit => 1
    t.integer "ycy1",                   :limit => 1
    t.integer "ycy2",                   :limit => 1
    t.string  "ycy2hv"
    t.integer "ycy3",                   :limit => 1
    t.integer "ycy4",                   :limit => 1
    t.integer "ycy5",                   :limit => 1
    t.integer "ycy6",                   :limit => 1
    t.integer "ycy7",                   :limit => 1
    t.integer "ycy8",                   :limit => 1
    t.integer "ycy9",                   :limit => 1
    t.string  "ycy9hv"
    t.integer "ycy10",                  :limit => 1
    t.integer "ycy11",                  :limit => 1
    t.integer "ycy12",                  :limit => 1
    t.integer "ycy13",                  :limit => 1
    t.integer "ycy14",                  :limit => 1
    t.integer "ycy15",                  :limit => 1
    t.integer "ycy16",                  :limit => 1
    t.integer "ycy17",                  :limit => 1
    t.integer "ycy18",                  :limit => 1
    t.integer "ycy19",                  :limit => 1
    t.integer "ycy20",                  :limit => 1
    t.integer "ycy21",                  :limit => 1
    t.integer "ycy22",                  :limit => 1
    t.integer "ycy23",                  :limit => 1
    t.integer "ycy24",                  :limit => 1
    t.integer "ycy25",                  :limit => 1
    t.integer "ycy26",                  :limit => 1
    t.integer "ycy27",                  :limit => 1
    t.integer "ycy28",                  :limit => 1
    t.integer "ycy29",                  :limit => 1
    t.string  "ycy29hv"
    t.integer "ycy30",                  :limit => 1
    t.integer "ycy31",                  :limit => 1
    t.integer "ycy32",                  :limit => 1
    t.integer "ycy33",                  :limit => 1
    t.integer "ycy34",                  :limit => 1
    t.integer "ycy35",                  :limit => 1
    t.integer "ycy36",                  :limit => 1
    t.integer "ycy37",                  :limit => 1
    t.integer "ycy38",                  :limit => 1
    t.integer "ycy39",                  :limit => 1
    t.integer "ycy40",                  :limit => 1
    t.string  "ycy40hv"
    t.integer "ycy41",                  :limit => 1
    t.integer "ycy42",                  :limit => 1
    t.integer "ycy43",                  :limit => 1
    t.integer "ycy44",                  :limit => 1
    t.integer "ycy45",                  :limit => 1
    t.integer "ycy46",                  :limit => 1
    t.string  "ycy46hv"
    t.integer "ycy47",                  :limit => 1
    t.integer "ycy48",                  :limit => 1
    t.integer "ycy49",                  :limit => 1
    t.integer "ycy50",                  :limit => 1
    t.integer "ycy51",                  :limit => 1
    t.integer "ycy52",                  :limit => 1
    t.integer "ycy53",                  :limit => 1
    t.integer "ycy54",                  :limit => 1
    t.integer "ycy55",                  :limit => 1
    t.integer "ycy56a",                 :limit => 1
    t.integer "ycy56b",                 :limit => 1
    t.integer "ycy56c",                 :limit => 1
    t.integer "ycy56d",                 :limit => 1
    t.string  "ycy56dhv"
    t.integer "ycy56e",                 :limit => 1
    t.integer "ycy56f",                 :limit => 1
    t.integer "ycy56g",                 :limit => 1
    t.integer "ycy56h",                 :limit => 1
    t.string  "ycy56hhv"
    t.integer "ycy57",                  :limit => 1
    t.integer "ycy58",                  :limit => 1
    t.string  "ycy58hv"
    t.integer "ycy59",                  :limit => 1
    t.integer "ycy60",                  :limit => 1
    t.integer "ycy61",                  :limit => 1
    t.integer "ycy62",                  :limit => 1
    t.integer "ycy63",                  :limit => 1
    t.integer "ycy64",                  :limit => 1
    t.integer "ycy65",                  :limit => 1
    t.integer "ycy66",                  :limit => 1
    t.string  "ycy66hv"
    t.integer "ycy67",                  :limit => 1
    t.integer "ycy68",                  :limit => 1
    t.integer "ycy69",                  :limit => 1
    t.integer "ycy70",                  :limit => 1
    t.string  "ycy70hv"
    t.integer "ycy71",                  :limit => 1
    t.integer "ycy72",                  :limit => 1
    t.integer "ycy73",                  :limit => 1
    t.integer "ycy74",                  :limit => 1
    t.integer "ycy75",                  :limit => 1
    t.integer "ycy76",                  :limit => 1
    t.integer "ycy77",                  :limit => 1
    t.integer "ycy78",                  :limit => 1
    t.integer "ycy79",                  :limit => 1
    t.string  "ycy79hv"
    t.integer "ycy80",                  :limit => 1
    t.integer "ycy81",                  :limit => 1
    t.integer "ycy82",                  :limit => 1
    t.integer "ycy83",                  :limit => 1
    t.string  "ycy83hv"
    t.integer "ycy84",                  :limit => 1
    t.string  "ycy84hv"
    t.integer "ycy85",                  :limit => 1
    t.string  "ycy85hv"
    t.integer "ycy86",                  :limit => 1
    t.integer "ycy87",                  :limit => 1
    t.integer "ycy88",                  :limit => 1
    t.integer "ycy89",                  :limit => 1
    t.integer "ycy90",                  :limit => 1
    t.integer "ycy91",                  :limit => 1
    t.integer "ycy92",                  :limit => 1
    t.integer "ycy93",                  :limit => 1
    t.integer "ycy94",                  :limit => 1
    t.integer "ycy95",                  :limit => 1
    t.integer "ycy96",                  :limit => 1
    t.integer "ycy97",                  :limit => 1
    t.integer "ycy98",                  :limit => 1
    t.integer "ycy99",                  :limit => 1
    t.integer "ycy100",                 :limit => 1
    t.string  "ycy100hv"
    t.integer "ycy101",                 :limit => 1
    t.integer "ycy102",                 :limit => 1
    t.integer "ycy103",                 :limit => 1
    t.integer "ycy104",                 :limit => 1
    t.integer "ycy105",                 :limit => 1
    t.string  "ycy105hv"
    t.integer "ycy106",                 :limit => 1
    t.integer "ycy107",                 :limit => 1
    t.integer "ycy108",                 :limit => 1
    t.integer "ycy109",                 :limit => 1
    t.integer "ycy110",                 :limit => 1
    t.integer "ycy111",                 :limit => 1
    t.integer "ycy112",                 :limit => 1
    t.integer "ycyispor",               :limit => 1
    t.integer "ycyiaspt",               :limit => 1
    t.integer "ycyibspt",               :limit => 1
    t.integer "ycyicspt",               :limit => 1
    t.integer "ycyiasp",                :limit => 1
    t.integer "ycyibsp",                :limit => 1
    t.integer "ycyicsp",                :limit => 1
    t.integer "ycyiaht",                :limit => 1
    t.integer "ycyiah",                 :limit => 1
    t.integer "ycyibh",                 :limit => 1
    t.integer "ycyibht",                :limit => 1
    t.integer "ycyicht",                :limit => 1
    t.integer "ycyich",                 :limit => 1
    t.integer "ycyiiia",                :limit => 1
    t.integer "ycyiiib",                :limit => 1
    t.integer "ycyiiic",                :limit => 1
    t.integer "ycyivja",                :limit => 1
    t.integer "ycyivjb",                :limit => 1
    t.integer "ycyivjc",                :limit => 1
    t.integer "yaviian1",               :limit => 1
    t.integer "yaviian2",               :limit => 1
  end

  add_index "export_variables_ycy_answers", ["journal_id"], :name => "index_export_variables_ycy_answers_on_journal_id"

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

  add_index "faqs", ["faq_section_id"], :name => "fk_faqs_faq_sections"

  create_table "group_permissions", :force => true do |t|
    t.integer "group_id"
    t.integer "permission_id"
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
  add_index "groups", ["parent_id"], :name => "index_groups_on_parent_id"
  add_index "groups", ["type"], :name => "index_groups_on_type"

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

  create_table "item_choices", :force => true do |t|
    t.string  "datatype",   :null => false
    t.string  "name",       :null => false
    t.integer "no_options"
  end

  create_table "item_options", :force => true do |t|
    t.integer "item_choice_id", :null => false
    t.string  "option",         :null => false
    t.string  "code",           :null => false
    t.string  "label",          :null => false
  end

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
  add_index "journal_entries", ["state"], :name => "index_journal_entries_on_state"
  add_index "journal_entries", ["survey_answer_id"], :name => "index_journal_entries_on_survey_answer_id"
  add_index "journal_entries", ["survey_id"], :name => "index_journal_entries_on_survey_id"
  add_index "journal_entries", ["user_id"], :name => "index_journal_entries_on_user_id"

  create_table "letters", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.text     "letter"
    t.string   "surveytype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letters", ["group_id"], :name => "index_letters_on_group_id"

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

  add_index "periods", ["active"], :name => "index_periods_on_active"
  add_index "periods", ["paid"], :name => "index_periods_on_paid"
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
  end

  create_table "questions", :force => true do |t|
    t.integer "survey_id",     :null => false
    t.integer "number",        :null => false
    t.integer "ratings_count"
  end

  add_index "questions", ["survey_id"], :name => "fk_questions_surveys"

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

  add_index "scores", ["score_group_id"], :name => "fk_scores_score_groups"
  add_index "scores", ["survey_id"], :name => "fk_scores_surveys"

  create_table "scores_surveys", :id => false, :force => true do |t|
    t.integer "score_id"
    t.integer "survey_id"
  end

  add_index "scores_surveys", ["score_id"], :name => "index_scores_surveys_on_score_id"
  add_index "scores_surveys", ["survey_id"], :name => "index_scores_surveys_on_survey_id"

  create_table "sph_counter", :id => false, :force => true do |t|
    t.integer "last_id",                  :null => false
    t.string  "table_name", :limit => 50, :null => false
  end

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
  add_index "subscriptions", ["survey_id"], :name => "index_subscriptions_on_survey_id"

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

  add_index "survey_answers", ["age"], :name => "index_survey_answers_on_age"
  add_index "survey_answers", ["center_id"], :name => "index_survey_answers_on_center_id"
  add_index "survey_answers", ["done"], :name => "index_survey_answers_on_done"
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
    t.integer   "delta"
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

  add_index "variables", ["col"], :name => "index_variables_on_col"
  add_index "variables", ["question_id"], :name => "fk_variables_questions"
  add_index "variables", ["question_id"], :name => "index_variables_on_question_id"
  add_index "variables", ["row"], :name => "index_variables_on_row"
  add_index "variables", ["survey_id"], :name => "fk_variables_surveys"

end
