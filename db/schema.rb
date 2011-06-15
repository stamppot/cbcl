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
    t.integer "answer_id",                :default => 0, :null => false
    t.integer "col",                      :default => 0, :null => false
    t.integer "row",                      :default => 0, :null => false
    t.string  "item",        :limit => 5
    t.boolean "rating"
    t.string  "value_text"
    t.boolean "text"
    t.integer "cell_type"
    t.integer "value"
    t.integer "variable_id", :limit => 2
  end

  add_index "answer_cells", ["answer_id"], :name => "index_answer_cells_on_answer_id"
  add_index "answer_cells", ["variable_id"], :name => "index_answer_cells_on_variable_id"

  create_table "answers", :force => true do |t|
    t.integer "survey_answer_id", :default => 0, :null => false
    t.integer "number",           :default => 0, :null => false
    t.integer "question_id",      :default => 0, :null => false
    t.integer "ratings_count"
  end

  add_index "answers", ["question_id"], :name => "fk_answers_questions"
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
    t.integer "code_book_id",    :null => false
    t.integer "question_id",     :null => false
    t.integer "question_number", :null => false
    t.string  "variable",        :null => false
    t.string  "item_type",       :null => false
    t.string  "item",            :null => false
    t.string  "datatype",        :null => false
    t.string  "description"
    t.string  "measure"
    t.integer "row",             :null => false
    t.integer "col",             :null => false
    t.integer "item_choice_id",  :null => false
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

  create_table "export_variables_survey_cc", :force => true do |t|
    t.integer "journal_id",        :limit => 3
    t.string  "cci1"
    t.integer "cci1_datatype",     :limit => 1
    t.string  "cci2"
    t.integer "cci2_datatype",     :limit => 1
    t.string  "cci3"
    t.integer "cci3_datatype",     :limit => 1
    t.string  "cci4"
    t.integer "cci4_datatype",     :limit => 1
    t.string  "cci5"
    t.integer "cci5_datatype",     :limit => 1
    t.string  "cci6"
    t.integer "cci6_datatype",     :limit => 1
    t.string  "cci7"
    t.integer "cci7_datatype",     :limit => 1
    t.string  "cci8"
    t.integer "cci8_datatype",     :limit => 1
    t.string  "cci9"
    t.integer "cci9_datatype",     :limit => 1
    t.string  "cci10"
    t.integer "cci10_datatype",    :limit => 1
    t.string  "cci11"
    t.integer "cci11_datatype",    :limit => 1
    t.string  "cci12"
    t.integer "cci12_datatype",    :limit => 1
    t.string  "cci13"
    t.integer "cci13_datatype",    :limit => 1
    t.string  "cci14"
    t.integer "cci14_datatype",    :limit => 1
    t.string  "cci15"
    t.integer "cci15_datatype",    :limit => 1
    t.string  "cci16"
    t.integer "cci16_datatype",    :limit => 1
    t.string  "cci17"
    t.integer "cci17_datatype",    :limit => 1
    t.string  "cci18"
    t.integer "cci18_datatype",    :limit => 1
    t.string  "cci19"
    t.integer "cci19_datatype",    :limit => 1
    t.string  "cci20"
    t.integer "cci20_datatype",    :limit => 1
    t.string  "cci21"
    t.integer "cci21_datatype",    :limit => 1
    t.string  "cci22"
    t.integer "cci22_datatype",    :limit => 1
    t.string  "cci23"
    t.integer "cci23_datatype",    :limit => 1
    t.string  "cci24"
    t.integer "cci24_datatype",    :limit => 1
    t.string  "cci24hv"
    t.integer "cci24hv_datatype",  :limit => 1
    t.string  "cci25"
    t.integer "cci25_datatype",    :limit => 1
    t.string  "cci26"
    t.integer "cci26_datatype",    :limit => 1
    t.string  "cci27"
    t.integer "cci27_datatype",    :limit => 1
    t.string  "cci28"
    t.integer "cci28_datatype",    :limit => 1
    t.string  "cci29"
    t.integer "cci29_datatype",    :limit => 1
    t.string  "cci30"
    t.integer "cci30_datatype",    :limit => 1
    t.string  "cci31"
    t.integer "cci31_datatype",    :limit => 1
    t.string  "cci31hv"
    t.integer "cci31hv_datatype",  :limit => 1
    t.string  "cci32"
    t.integer "cci32_datatype",    :limit => 1
    t.string  "cci32hv"
    t.integer "cci32hv_datatype",  :limit => 1
    t.string  "cci33"
    t.integer "cci33_datatype",    :limit => 1
    t.string  "cci34"
    t.integer "cci34_datatype",    :limit => 1
    t.string  "cci35"
    t.integer "cci35_datatype",    :limit => 1
    t.string  "cci36"
    t.integer "cci36_datatype",    :limit => 1
    t.string  "cci37"
    t.integer "cci37_datatype",    :limit => 1
    t.string  "cci38"
    t.integer "cci38_datatype",    :limit => 1
    t.string  "cci39"
    t.integer "cci39_datatype",    :limit => 1
    t.string  "cci40"
    t.integer "cci40_datatype",    :limit => 1
    t.string  "cci41"
    t.integer "cci41_datatype",    :limit => 1
    t.string  "cci42"
    t.integer "cci42_datatype",    :limit => 1
    t.string  "cci43"
    t.integer "cci43_datatype",    :limit => 1
    t.string  "cci44"
    t.integer "cci44_datatype",    :limit => 1
    t.string  "cci45"
    t.integer "cci45_datatype",    :limit => 1
    t.string  "cci46"
    t.integer "cci46_datatype",    :limit => 1
    t.string  "cci46hv"
    t.integer "cci46hv_datatype",  :limit => 1
    t.string  "cci47"
    t.integer "cci47_datatype",    :limit => 1
    t.string  "cci48"
    t.integer "cci48_datatype",    :limit => 1
    t.string  "cci49"
    t.integer "cci49_datatype",    :limit => 1
    t.string  "cci50"
    t.integer "cci50_datatype",    :limit => 1
    t.string  "cci51"
    t.integer "cci51_datatype",    :limit => 1
    t.string  "cci52"
    t.integer "cci52_datatype",    :limit => 1
    t.string  "cci53"
    t.integer "cci53_datatype",    :limit => 1
    t.string  "cci54"
    t.integer "cci54_datatype",    :limit => 1
    t.string  "cci54hv"
    t.integer "cci54hv_datatype",  :limit => 1
    t.string  "cci55"
    t.integer "cci55_datatype",    :limit => 1
    t.string  "cci56"
    t.integer "cci56_datatype",    :limit => 1
    t.string  "cci57"
    t.integer "cci57_datatype",    :limit => 1
    t.string  "cci58"
    t.integer "cci58_datatype",    :limit => 1
    t.string  "cci59"
    t.integer "cci59_datatype",    :limit => 1
    t.string  "cci60"
    t.integer "cci60_datatype",    :limit => 1
    t.string  "cci61"
    t.integer "cci61_datatype",    :limit => 1
    t.string  "cci62"
    t.integer "cci62_datatype",    :limit => 1
    t.string  "cci63"
    t.integer "cci63_datatype",    :limit => 1
    t.string  "cci64"
    t.integer "cci64_datatype",    :limit => 1
    t.string  "cci65"
    t.integer "cci65_datatype",    :limit => 1
    t.string  "cci66"
    t.integer "cci66_datatype",    :limit => 1
    t.string  "cci67"
    t.integer "cci67_datatype",    :limit => 1
    t.string  "cci68"
    t.integer "cci68_datatype",    :limit => 1
    t.string  "cci69"
    t.integer "cci69_datatype",    :limit => 1
    t.string  "cci70"
    t.integer "cci70_datatype",    :limit => 1
    t.string  "cci71"
    t.integer "cci71_datatype",    :limit => 1
    t.string  "cci72"
    t.integer "cci72_datatype",    :limit => 1
    t.string  "cci73"
    t.integer "cci73_datatype",    :limit => 1
    t.string  "cci74"
    t.integer "cci74_datatype",    :limit => 1
    t.string  "cci74hv"
    t.integer "cci74hv_datatype",  :limit => 1
    t.string  "cci75"
    t.integer "cci75_datatype",    :limit => 1
    t.string  "cci76"
    t.integer "cci76_datatype",    :limit => 1
    t.string  "cci76hv"
    t.integer "cci76hv_datatype",  :limit => 1
    t.string  "cci77"
    t.integer "cci77_datatype",    :limit => 1
    t.string  "cci78"
    t.integer "cci78_datatype",    :limit => 1
    t.string  "cci79"
    t.integer "cci79_datatype",    :limit => 1
    t.string  "cci80"
    t.integer "cci80_datatype",    :limit => 1
    t.string  "cci80hv"
    t.integer "cci80hv_datatype",  :limit => 1
    t.string  "cci81"
    t.integer "cci81_datatype",    :limit => 1
    t.string  "cci82"
    t.integer "cci82_datatype",    :limit => 1
    t.string  "cci83"
    t.integer "cci83_datatype",    :limit => 1
    t.string  "cci84"
    t.integer "cci84_datatype",    :limit => 1
    t.string  "cci85"
    t.integer "cci85_datatype",    :limit => 1
    t.string  "cci86"
    t.integer "cci86_datatype",    :limit => 1
    t.string  "cci87"
    t.integer "cci87_datatype",    :limit => 1
    t.string  "cci88"
    t.integer "cci88_datatype",    :limit => 1
    t.string  "cci89"
    t.integer "cci89_datatype",    :limit => 1
    t.string  "cci90"
    t.integer "cci90_datatype",    :limit => 1
    t.string  "cci91"
    t.integer "cci91_datatype",    :limit => 1
    t.string  "cci92"
    t.integer "cci92_datatype",    :limit => 1
    t.string  "cci92hv"
    t.integer "cci92hv_datatype",  :limit => 1
    t.string  "cci93"
    t.integer "cci93_datatype",    :limit => 1
    t.string  "cci94"
    t.integer "cci94_datatype",    :limit => 1
    t.string  "cci95"
    t.integer "cci95_datatype",    :limit => 1
    t.string  "cci96"
    t.integer "cci96_datatype",    :limit => 1
    t.string  "cci97"
    t.integer "cci97_datatype",    :limit => 1
    t.string  "cci98"
    t.integer "cci98_datatype",    :limit => 1
    t.string  "cci99"
    t.integer "cci99_datatype",    :limit => 1
    t.string  "cci100"
    t.integer "cci100_datatype",   :limit => 1
    t.string  "cci100hv"
    t.integer "cci100hv_datatype", :limit => 1
    t.string  "ccii1"
    t.integer "ccii1_datatype",    :limit => 1
    t.string  "cciihv"
    t.integer "cciihv_datatype",   :limit => 1
    t.string  "ccii2hv"
    t.integer "ccii2hv_datatype",  :limit => 1
    t.string  "ccii3hv"
    t.integer "ccii3hv_datatype",  :limit => 1
    t.string  "cciii1"
    t.integer "cciii1_datatype",   :limit => 1
    t.string  "cciii2hv"
    t.integer "cciii2hv_datatype", :limit => 1
    t.string  "cciii3"
    t.integer "cciii3_datatype",   :limit => 1
    t.string  "cciii4"
    t.integer "cciii4_datatype",   :limit => 1
    t.string  "cciii4hv"
    t.integer "cciii4hv_datatype", :limit => 1
    t.string  "cciii5"
    t.integer "cciii5_datatype",   :limit => 1
    t.string  "cciii5hv"
    t.integer "cciii5hv_datatype", :limit => 1
    t.string  "cciii7"
    t.integer "cciii7_datatype",   :limit => 1
    t.string  "cciii6hv"
    t.integer "cciii6hv_datatype", :limit => 1
    t.string  "cciii7hv"
    t.integer "cciii7hv_datatype", :limit => 1
  end

  add_index "export_variables_survey_cc", ["journal_id"], :name => "index_export_variables_survey_cc_on_journal_id"

  create_table "export_variables_survey_ccy", :force => true do |t|
    t.integer "journal_id",          :limit => 3
    t.string  "ccyi"
    t.integer "ccyi_datatype",       :limit => 1
    t.string  "ccyi1a"
    t.integer "ccyi1a_datatype",     :limit => 1
    t.string  "ccyi1b"
    t.integer "ccyi1b_datatype",     :limit => 1
    t.string  "ccyi1c"
    t.integer "ccyi1c_datatype",     :limit => 1
    t.string  "ccyii"
    t.integer "ccyii_datatype",      :limit => 1
    t.string  "ccyii1a"
    t.integer "ccyii1a_datatype",    :limit => 1
    t.string  "ccyii1b"
    t.integer "ccyii1b_datatype",    :limit => 1
    t.string  "ccyii1c"
    t.integer "ccyii1c_datatype",    :limit => 1
    t.string  "ccyiii"
    t.integer "ccyiii_datatype",     :limit => 1
    t.string  "ccyiii1a"
    t.integer "ccyiii1a_datatype",   :limit => 1
    t.string  "ccyiii1b"
    t.integer "ccyiii1b_datatype",   :limit => 1
    t.string  "ccyiii1c"
    t.integer "ccyiii1c_datatype",   :limit => 1
    t.string  "ccyiv"
    t.integer "ccyiv_datatype",      :limit => 1
    t.string  "ccyiv1a"
    t.integer "ccyiv1a_datatype",    :limit => 1
    t.string  "ccyiv1b"
    t.integer "ccyiv1b_datatype",    :limit => 1
    t.string  "ccyiv1c"
    t.integer "ccyiv1c_datatype",    :limit => 1
    t.string  "ccyv1"
    t.integer "ccyv1_datatype",      :limit => 1
    t.string  "ccyv2"
    t.integer "ccyv2_datatype",      :limit => 1
    t.string  "ccyvi1a"
    t.integer "ccyvi1a_datatype",    :limit => 1
    t.string  "ccyvi1b"
    t.integer "ccyvi1b_datatype",    :limit => 1
    t.string  "ccyvi1c"
    t.integer "ccyvi1c_datatype",    :limit => 1
    t.string  "ccyvi1d"
    t.integer "ccyvi1d_datatype",    :limit => 1
    t.string  "ccyvii"
    t.integer "ccyvii_datatype",     :limit => 1
    t.string  "ccyviihv"
    t.integer "ccyviihv_datatype",   :limit => 1
    t.string  "ccyvii1a"
    t.integer "ccyvii1a_datatype",   :limit => 1
    t.string  "ccyvii1b"
    t.integer "ccyvii1b_datatype",   :limit => 1
    t.string  "ccyvii1c"
    t.integer "ccyvii1c_datatype",   :limit => 1
    t.string  "ccyvii1d"
    t.integer "ccyvii1d_datatype",   :limit => 1
    t.string  "ccyvii1e"
    t.integer "ccyvii1e_datatype",   :limit => 1
    t.string  "ccyvii1f"
    t.integer "ccyvii1f_datatype",   :limit => 1
    t.string  "ccyvii1g"
    t.integer "ccyvii1g_datatype",   :limit => 1
    t.string  "ccyvii2"
    t.integer "ccyvii2_datatype",    :limit => 1
    t.string  "ccyvii3"
    t.integer "ccyvii3_datatype",    :limit => 1
    t.string  "ccyvii3hv"
    t.integer "ccyvii3hv_datatype",  :limit => 1
    t.string  "ccyvii4"
    t.integer "ccyvii4_datatype",    :limit => 1
    t.string  "ccyvii4hv"
    t.integer "ccyvii4hv_datatype",  :limit => 1
    t.string  "ccyvii5"
    t.integer "ccyvii5_datatype",    :limit => 1
    t.string  "ccyviii1"
    t.integer "ccyviii1_datatype",   :limit => 1
    t.string  "ccyviiihv"
    t.integer "ccyviiihv_datatype",  :limit => 1
    t.string  "ccyviii2hv"
    t.integer "ccyviii2hv_datatype", :limit => 1
    t.string  "ccyviii3hv"
    t.integer "ccyviii3hv_datatype", :limit => 1
    t.string  "ccyx1"
    t.integer "ccyx1_datatype",      :limit => 1
    t.string  "ccyx2"
    t.integer "ccyx2_datatype",      :limit => 1
    t.string  "ccyx2hv"
    t.integer "ccyx2hv_datatype",    :limit => 1
    t.string  "ccyx3"
    t.integer "ccyx3_datatype",      :limit => 1
    t.string  "ccyx4"
    t.integer "ccyx4_datatype",      :limit => 1
    t.string  "ccyx5"
    t.integer "ccyx5_datatype",      :limit => 1
    t.string  "ccyx6"
    t.integer "ccyx6_datatype",      :limit => 1
    t.string  "ccyx7"
    t.integer "ccyx7_datatype",      :limit => 1
    t.string  "ccyx8"
    t.integer "ccyx8_datatype",      :limit => 1
    t.string  "ccyx9"
    t.integer "ccyx9_datatype",      :limit => 1
    t.string  "ccyx9hv"
    t.integer "ccyx9hv_datatype",    :limit => 1
    t.string  "ccyx10"
    t.integer "ccyx10_datatype",     :limit => 1
    t.string  "ccyx11"
    t.integer "ccyx11_datatype",     :limit => 1
    t.string  "ccyx12"
    t.integer "ccyx12_datatype",     :limit => 1
    t.string  "ccyx13"
    t.integer "ccyx13_datatype",     :limit => 1
    t.string  "ccyx14"
    t.integer "ccyx14_datatype",     :limit => 1
    t.string  "ccyx15"
    t.integer "ccyx15_datatype",     :limit => 1
    t.string  "ccyx16"
    t.integer "ccyx16_datatype",     :limit => 1
    t.string  "ccyx17"
    t.integer "ccyx17_datatype",     :limit => 1
    t.string  "ccyx18"
    t.integer "ccyx18_datatype",     :limit => 1
    t.string  "ccyx19"
    t.integer "ccyx19_datatype",     :limit => 1
    t.string  "ccyx20"
    t.integer "ccyx20_datatype",     :limit => 1
    t.string  "ccyx21"
    t.integer "ccyx21_datatype",     :limit => 1
    t.string  "ccyx22"
    t.integer "ccyx22_datatype",     :limit => 1
    t.string  "ccyx23"
    t.integer "ccyx23_datatype",     :limit => 1
    t.string  "ccyx24"
    t.integer "ccyx24_datatype",     :limit => 1
    t.string  "ccyx25"
    t.integer "ccyx25_datatype",     :limit => 1
    t.string  "ccyx26"
    t.integer "ccyx26_datatype",     :limit => 1
    t.string  "ccyx27"
    t.integer "ccyx27_datatype",     :limit => 1
    t.string  "ccyx28"
    t.integer "ccyx28_datatype",     :limit => 1
    t.string  "ccyx29"
    t.integer "ccyx29_datatype",     :limit => 1
    t.string  "ccyx29hv"
    t.integer "ccyx29hv_datatype",   :limit => 1
    t.string  "ccyx30"
    t.integer "ccyx30_datatype",     :limit => 1
    t.string  "ccyx31"
    t.integer "ccyx31_datatype",     :limit => 1
    t.string  "ccyx32"
    t.integer "ccyx32_datatype",     :limit => 1
    t.string  "ccyx33"
    t.integer "ccyx33_datatype",     :limit => 1
    t.string  "ccyx34"
    t.integer "ccyx34_datatype",     :limit => 1
    t.string  "ccyx35"
    t.integer "ccyx35_datatype",     :limit => 1
    t.string  "ccyx36"
    t.integer "ccyx36_datatype",     :limit => 1
    t.string  "ccyx37"
    t.integer "ccyx37_datatype",     :limit => 1
    t.string  "ccyx38"
    t.integer "ccyx38_datatype",     :limit => 1
    t.string  "ccyx39"
    t.integer "ccyx39_datatype",     :limit => 1
    t.string  "ccyx40"
    t.integer "ccyx40_datatype",     :limit => 1
    t.string  "ccyx40hv"
    t.integer "ccyx40hv_datatype",   :limit => 1
    t.string  "ccyx41"
    t.integer "ccyx41_datatype",     :limit => 1
    t.string  "ccyx42"
    t.integer "ccyx42_datatype",     :limit => 1
    t.string  "ccyx43"
    t.integer "ccyx43_datatype",     :limit => 1
    t.string  "ccyx44"
    t.integer "ccyx44_datatype",     :limit => 1
    t.string  "ccyx45"
    t.integer "ccyx45_datatype",     :limit => 1
    t.string  "ccyx46"
    t.integer "ccyx46_datatype",     :limit => 1
    t.string  "ccyx46hv"
    t.integer "ccyx46hv_datatype",   :limit => 1
    t.string  "ccyx47"
    t.integer "ccyx47_datatype",     :limit => 1
    t.string  "ccyx48"
    t.integer "ccyx48_datatype",     :limit => 1
    t.string  "ccyx49"
    t.integer "ccyx49_datatype",     :limit => 1
    t.string  "ccyx50"
    t.integer "ccyx50_datatype",     :limit => 1
    t.string  "ccyx51"
    t.integer "ccyx51_datatype",     :limit => 1
    t.string  "ccyx52"
    t.integer "ccyx52_datatype",     :limit => 1
    t.string  "ccyx53"
    t.integer "ccyx53_datatype",     :limit => 1
    t.string  "ccyx54"
    t.integer "ccyx54_datatype",     :limit => 1
    t.string  "ccyx55"
    t.integer "ccyx55_datatype",     :limit => 1
    t.string  "ccyx56a"
    t.integer "ccyx56a_datatype",    :limit => 1
    t.string  "ccyx56b"
    t.integer "ccyx56b_datatype",    :limit => 1
    t.string  "ccyx56c"
    t.integer "ccyx56c_datatype",    :limit => 1
    t.string  "ccyx56d"
    t.integer "ccyx56d_datatype",    :limit => 1
    t.string  "ccyx56dhv"
    t.integer "ccyx56dhv_datatype",  :limit => 1
    t.string  "ccyx56e"
    t.integer "ccyx56e_datatype",    :limit => 1
    t.string  "ccyx56f"
    t.integer "ccyx56f_datatype",    :limit => 1
    t.string  "ccyx56g"
    t.integer "ccyx56g_datatype",    :limit => 1
    t.string  "ccyx56h"
    t.integer "ccyx56h_datatype",    :limit => 1
    t.string  "ccyx56hhv"
    t.integer "ccyx56hhv_datatype",  :limit => 1
    t.string  "ccyx57"
    t.integer "ccyx57_datatype",     :limit => 1
    t.string  "ccyx58"
    t.integer "ccyx58_datatype",     :limit => 1
    t.string  "ccyx58hv"
    t.integer "ccyx58hv_datatype",   :limit => 1
    t.string  "ccyx59"
    t.integer "ccyx59_datatype",     :limit => 1
    t.string  "ccyx60"
    t.integer "ccyx60_datatype",     :limit => 1
    t.string  "ccyx61"
    t.integer "ccyx61_datatype",     :limit => 1
    t.string  "ccyx62"
    t.integer "ccyx62_datatype",     :limit => 1
    t.string  "ccyx63"
    t.integer "ccyx63_datatype",     :limit => 1
    t.string  "ccyx64"
    t.integer "ccyx64_datatype",     :limit => 1
    t.string  "ccyx65"
    t.integer "ccyx65_datatype",     :limit => 1
    t.string  "ccyx66"
    t.integer "ccyx66_datatype",     :limit => 1
    t.string  "ccyx66hv"
    t.integer "ccyx66hv_datatype",   :limit => 1
    t.string  "ccyx67"
    t.integer "ccyx67_datatype",     :limit => 1
    t.string  "ccyx68"
    t.integer "ccyx68_datatype",     :limit => 1
    t.string  "ccyx69"
    t.integer "ccyx69_datatype",     :limit => 1
    t.string  "ccyx70"
    t.integer "ccyx70_datatype",     :limit => 1
    t.string  "ccyx70hv"
    t.integer "ccyx70hv_datatype",   :limit => 1
    t.string  "ccyx71"
    t.integer "ccyx71_datatype",     :limit => 1
    t.string  "ccyx72"
    t.integer "ccyx72_datatype",     :limit => 1
    t.string  "ccyx73"
    t.integer "ccyx73_datatype",     :limit => 1
    t.string  "ccyx73hv"
    t.integer "ccyx73hv_datatype",   :limit => 1
    t.string  "ccyx74"
    t.integer "ccyx74_datatype",     :limit => 1
    t.string  "ccyx75"
    t.integer "ccyx75_datatype",     :limit => 1
    t.string  "ccyx76"
    t.integer "ccyx76_datatype",     :limit => 1
    t.string  "ccyx77"
    t.integer "ccyx77_datatype",     :limit => 1
    t.string  "ccyx77hv"
    t.integer "ccyx77hv_datatype",   :limit => 1
    t.string  "ccyx78"
    t.integer "ccyx78_datatype",     :limit => 1
    t.string  "ccyx79"
    t.integer "ccyx79_datatype",     :limit => 1
    t.string  "ccyx79hv"
    t.integer "ccyx79hv_datatype",   :limit => 1
    t.string  "ccyx80"
    t.integer "ccyx80_datatype",     :limit => 1
    t.string  "ccyx81"
    t.integer "ccyx81_datatype",     :limit => 1
    t.string  "ccyx82"
    t.integer "ccyx82_datatype",     :limit => 1
    t.string  "ccyx83"
    t.integer "ccyx83_datatype",     :limit => 1
    t.string  "ccyx83hv"
    t.integer "ccyx83hv_datatype",   :limit => 1
    t.string  "ccyx84"
    t.integer "ccyx84_datatype",     :limit => 1
    t.string  "ccyx84hv"
    t.integer "ccyx84hv_datatype",   :limit => 1
    t.string  "ccyx85"
    t.integer "ccyx85_datatype",     :limit => 1
    t.string  "ccyx85hv"
    t.integer "ccyx85hv_datatype",   :limit => 1
    t.string  "ccyx86"
    t.integer "ccyx86_datatype",     :limit => 1
    t.string  "ccyx87"
    t.integer "ccyx87_datatype",     :limit => 1
    t.string  "ccyx88"
    t.integer "ccyx88_datatype",     :limit => 1
    t.string  "ccyx89"
    t.integer "ccyx89_datatype",     :limit => 1
    t.string  "ccyx90"
    t.integer "ccyx90_datatype",     :limit => 1
    t.string  "ccyx91"
    t.integer "ccyx91_datatype",     :limit => 1
    t.string  "ccyx92"
    t.integer "ccyx92_datatype",     :limit => 1
    t.string  "ccyx92hv"
    t.integer "ccyx92hv_datatype",   :limit => 1
    t.string  "ccyx93"
    t.integer "ccyx93_datatype",     :limit => 1
    t.string  "ccyx94"
    t.integer "ccyx94_datatype",     :limit => 1
    t.string  "ccyx95"
    t.integer "ccyx95_datatype",     :limit => 1
    t.string  "ccyx96"
    t.integer "ccyx96_datatype",     :limit => 1
    t.string  "ccyx97"
    t.integer "ccyx97_datatype",     :limit => 1
    t.string  "ccyx98"
    t.integer "ccyx98_datatype",     :limit => 1
    t.string  "ccyx99"
    t.integer "ccyx99_datatype",     :limit => 1
    t.string  "ccyx100"
    t.integer "ccyx100_datatype",    :limit => 1
    t.string  "ccyx100hv"
    t.integer "ccyx100hv_datatype",  :limit => 1
    t.string  "ccyx101"
    t.integer "ccyx101_datatype",    :limit => 1
    t.string  "ccyx102"
    t.integer "ccyx102_datatype",    :limit => 1
    t.string  "ccyx103"
    t.integer "ccyx103_datatype",    :limit => 1
    t.string  "ccyx104"
    t.integer "ccyx104_datatype",    :limit => 1
    t.string  "ccyx105"
    t.integer "ccyx105_datatype",    :limit => 1
    t.string  "ccyx105hv"
    t.integer "ccyx105hv_datatype",  :limit => 1
    t.string  "ccyx106"
    t.integer "ccyx106_datatype",    :limit => 1
    t.string  "ccyx107"
    t.integer "ccyx107_datatype",    :limit => 1
    t.string  "ccyx108"
    t.integer "ccyx108_datatype",    :limit => 1
    t.string  "ccyx109"
    t.integer "ccyx109_datatype",    :limit => 1
    t.string  "ccyx110"
    t.integer "ccyx110_datatype",    :limit => 1
    t.string  "ccyx111"
    t.integer "ccyx111_datatype",    :limit => 1
    t.string  "ccyx112"
    t.integer "ccyx112_datatype",    :limit => 1
    t.string  "ccyxhv"
    t.integer "ccyxhv_datatype",     :limit => 1
  end

  add_index "export_variables_survey_ccy", ["journal_id"], :name => "index_export_variables_survey_ccy_on_journal_id"

  create_table "export_variables_survey_ct", :force => true do |t|
    t.integer "journal_id",          :limit => 3
    t.string  "cti1hv"
    t.integer "cti1hv_datatype",     :limit => 1
    t.string  "cti2"
    t.integer "cti2_datatype",       :limit => 1
    t.string  "cti2hv"
    t.integer "cti2hv_datatype",     :limit => 1
    t.string  "ctiihv"
    t.integer "ctiihv_datatype",     :limit => 1
    t.string  "ctiii1hv"
    t.integer "ctiii1hv_datatype",   :limit => 1
    t.string  "ctiv1hv"
    t.integer "ctiv1hv_datatype",    :limit => 1
    t.string  "ctv1"
    t.integer "ctv1_datatype",       :limit => 1
    t.string  "ctvi1"
    t.integer "ctvi1_datatype",      :limit => 1
    t.string  "ctvi1hv"
    t.integer "ctvi1hv_datatype",    :limit => 1
    t.string  "ctvii1"
    t.integer "ctvii1_datatype",     :limit => 1
    t.string  "ctvii2"
    t.integer "ctvii2_datatype",     :limit => 1
    t.string  "ctvii3"
    t.integer "ctvii3_datatype",     :limit => 1
    t.string  "ctvii4"
    t.integer "ctvii4_datatype",     :limit => 1
    t.string  "ctvii5"
    t.integer "ctvii5_datatype",     :limit => 1
    t.string  "ctvii6"
    t.integer "ctvii6_datatype",     :limit => 1
    t.string  "ctvii7"
    t.integer "ctvii7_datatype",     :limit => 1
    t.string  "ctvii8"
    t.integer "ctvii8_datatype",     :limit => 1
    t.string  "ctvii9"
    t.integer "ctvii9_datatype",     :limit => 1
    t.string  "ctvii10"
    t.integer "ctvii10_datatype",    :limit => 1
    t.string  "ctvii11"
    t.integer "ctvii11_datatype",    :limit => 1
    t.string  "ctvii12"
    t.integer "ctvii12_datatype",    :limit => 1
    t.string  "ctvii13"
    t.integer "ctvii13_datatype",    :limit => 1
    t.string  "ctvii14"
    t.integer "ctvii14_datatype",    :limit => 1
    t.string  "ctvii15"
    t.integer "ctvii15_datatype",    :limit => 1
    t.string  "ctvii16"
    t.integer "ctvii16_datatype",    :limit => 1
    t.string  "ctvii17"
    t.integer "ctvii17_datatype",    :limit => 1
    t.string  "ctvii18"
    t.integer "ctvii18_datatype",    :limit => 1
    t.string  "ctvii19"
    t.integer "ctvii19_datatype",    :limit => 1
    t.string  "ctvii20"
    t.integer "ctvii20_datatype",    :limit => 1
    t.string  "ctvii21"
    t.integer "ctvii21_datatype",    :limit => 1
    t.string  "ctvii22"
    t.integer "ctvii22_datatype",    :limit => 1
    t.string  "ctvii23"
    t.integer "ctvii23_datatype",    :limit => 1
    t.string  "ctvii24"
    t.integer "ctvii24_datatype",    :limit => 1
    t.string  "ctvii25"
    t.integer "ctvii25_datatype",    :limit => 1
    t.string  "ctvii26"
    t.integer "ctvii26_datatype",    :limit => 1
    t.string  "ctvii27"
    t.integer "ctvii27_datatype",    :limit => 1
    t.string  "ctvii28"
    t.integer "ctvii28_datatype",    :limit => 1
    t.string  "ctvii29"
    t.integer "ctvii29_datatype",    :limit => 1
    t.string  "ctvii30"
    t.integer "ctvii30_datatype",    :limit => 1
    t.string  "ctvii31"
    t.integer "ctvii31_datatype",    :limit => 1
    t.string  "ctvii31hv"
    t.integer "ctvii31hv_datatype",  :limit => 1
    t.string  "ctvii32"
    t.integer "ctvii32_datatype",    :limit => 1
    t.string  "ctvii32hv"
    t.integer "ctvii32hv_datatype",  :limit => 1
    t.string  "ctvii33"
    t.integer "ctvii33_datatype",    :limit => 1
    t.string  "ctvii34"
    t.integer "ctvii34_datatype",    :limit => 1
    t.string  "ctvii35"
    t.integer "ctvii35_datatype",    :limit => 1
    t.string  "ctvii36"
    t.integer "ctvii36_datatype",    :limit => 1
    t.string  "ctvii37"
    t.integer "ctvii37_datatype",    :limit => 1
    t.string  "ctvii38"
    t.integer "ctvii38_datatype",    :limit => 1
    t.string  "ctvii39"
    t.integer "ctvii39_datatype",    :limit => 1
    t.string  "ctvii40"
    t.integer "ctvii40_datatype",    :limit => 1
    t.string  "ctvii41"
    t.integer "ctvii41_datatype",    :limit => 1
    t.string  "ctvii42"
    t.integer "ctvii42_datatype",    :limit => 1
    t.string  "ctvii43"
    t.integer "ctvii43_datatype",    :limit => 1
    t.string  "ctvii44"
    t.integer "ctvii44_datatype",    :limit => 1
    t.string  "ctvii45"
    t.integer "ctvii45_datatype",    :limit => 1
    t.string  "ctvii46"
    t.integer "ctvii46_datatype",    :limit => 1
    t.string  "ctvii46hv"
    t.integer "ctvii46hv_datatype",  :limit => 1
    t.string  "ctvii47"
    t.integer "ctvii47_datatype",    :limit => 1
    t.string  "ctvii48"
    t.integer "ctvii48_datatype",    :limit => 1
    t.string  "ctvii49"
    t.integer "ctvii49_datatype",    :limit => 1
    t.string  "ctvii50"
    t.integer "ctvii50_datatype",    :limit => 1
    t.string  "ctvii51"
    t.integer "ctvii51_datatype",    :limit => 1
    t.string  "ctvii52"
    t.integer "ctvii52_datatype",    :limit => 1
    t.string  "ctvii53"
    t.integer "ctvii53_datatype",    :limit => 1
    t.string  "ctvii54"
    t.integer "ctvii54_datatype",    :limit => 1
    t.string  "ctvii54hv"
    t.integer "ctvii54hv_datatype",  :limit => 1
    t.string  "ctvii55"
    t.integer "ctvii55_datatype",    :limit => 1
    t.string  "ctvii56"
    t.integer "ctvii56_datatype",    :limit => 1
    t.string  "ctvii57"
    t.integer "ctvii57_datatype",    :limit => 1
    t.string  "ctvii58"
    t.integer "ctvii58_datatype",    :limit => 1
    t.string  "ctvii59"
    t.integer "ctvii59_datatype",    :limit => 1
    t.string  "ctvii60"
    t.integer "ctvii60_datatype",    :limit => 1
    t.string  "ctvii61"
    t.integer "ctvii61_datatype",    :limit => 1
    t.string  "ctvii62"
    t.integer "ctvii62_datatype",    :limit => 1
    t.string  "ctvii63"
    t.integer "ctvii63_datatype",    :limit => 1
    t.string  "ctvii64"
    t.integer "ctvii64_datatype",    :limit => 1
    t.string  "ctvii65"
    t.integer "ctvii65_datatype",    :limit => 1
    t.string  "ctvii66"
    t.integer "ctvii66_datatype",    :limit => 1
    t.string  "ctvii67"
    t.integer "ctvii67_datatype",    :limit => 1
    t.string  "ctvii68"
    t.integer "ctvii68_datatype",    :limit => 1
    t.string  "ctvii69"
    t.integer "ctvii69_datatype",    :limit => 1
    t.string  "ctvii70"
    t.integer "ctvii70_datatype",    :limit => 1
    t.string  "ctvii71"
    t.integer "ctvii71_datatype",    :limit => 1
    t.string  "ctvii72"
    t.integer "ctvii72_datatype",    :limit => 1
    t.string  "ctvii73"
    t.integer "ctvii73_datatype",    :limit => 1
    t.string  "ctvii74"
    t.integer "ctvii74_datatype",    :limit => 1
    t.string  "ctvii75"
    t.integer "ctvii75_datatype",    :limit => 1
    t.string  "ctvii76"
    t.integer "ctvii76_datatype",    :limit => 1
    t.string  "ctvii76hv"
    t.integer "ctvii76hv_datatype",  :limit => 1
    t.string  "ctvii77"
    t.integer "ctvii77_datatype",    :limit => 1
    t.string  "ctvii78"
    t.integer "ctvii78_datatype",    :limit => 1
    t.string  "ctvii79"
    t.integer "ctvii79_datatype",    :limit => 1
    t.string  "ctvii80"
    t.integer "ctvii80_datatype",    :limit => 1
    t.string  "ctvii80hv"
    t.integer "ctvii80hv_datatype",  :limit => 1
    t.string  "ctvii81"
    t.integer "ctvii81_datatype",    :limit => 1
    t.string  "ctvii82"
    t.integer "ctvii82_datatype",    :limit => 1
    t.string  "ctvii83"
    t.integer "ctvii83_datatype",    :limit => 1
    t.string  "ctvii84"
    t.integer "ctvii84_datatype",    :limit => 1
    t.string  "ctvii85"
    t.integer "ctvii85_datatype",    :limit => 1
    t.string  "ctvii86"
    t.integer "ctvii86_datatype",    :limit => 1
    t.string  "ctvii87"
    t.integer "ctvii87_datatype",    :limit => 1
    t.string  "ctvii88"
    t.integer "ctvii88_datatype",    :limit => 1
    t.string  "ctvii89"
    t.integer "ctvii89_datatype",    :limit => 1
    t.string  "ctvii90"
    t.integer "ctvii90_datatype",    :limit => 1
    t.string  "ctvii91"
    t.integer "ctvii91_datatype",    :limit => 1
    t.string  "ctvii92"
    t.integer "ctvii92_datatype",    :limit => 1
    t.string  "ctvii92hv"
    t.integer "ctvii92hv_datatype",  :limit => 1
    t.string  "ctvii93"
    t.integer "ctvii93_datatype",    :limit => 1
    t.string  "ctvii94"
    t.integer "ctvii94_datatype",    :limit => 1
    t.string  "ctvii95"
    t.integer "ctvii95_datatype",    :limit => 1
    t.string  "ctvii96"
    t.integer "ctvii96_datatype",    :limit => 1
    t.string  "ctvii97"
    t.integer "ctvii97_datatype",    :limit => 1
    t.string  "ctvii98"
    t.integer "ctvii98_datatype",    :limit => 1
    t.string  "ctvii99"
    t.integer "ctvii99_datatype",    :limit => 1
    t.string  "ctvii100"
    t.integer "ctvii100_datatype",   :limit => 1
    t.string  "ctvii100hv"
    t.integer "ctvii100hv_datatype", :limit => 1
    t.string  "ctviii1"
    t.integer "ctviii1_datatype",    :limit => 1
    t.string  "ctviii1hv"
    t.integer "ctviii1hv_datatype",  :limit => 1
    t.string  "ctviii2hv"
    t.integer "ctviii2hv_datatype",  :limit => 1
    t.string  "ctviii3hv"
    t.integer "ctviii3hv_datatype",  :limit => 1
  end

  add_index "export_variables_survey_ct", ["journal_id"], :name => "index_export_variables_survey_ct_on_journal_id"

  create_table "export_variables_survey_tt", :force => true do |t|
    t.integer "journal_id",          :limit => 3
    t.string  "tt"
    t.integer "tt_datatype",         :limit => 1
    t.string  "tthv"
    t.integer "tthv_datatype",       :limit => 1
    t.string  "ttii1"
    t.integer "ttii1_datatype",      :limit => 1
    t.string  "ttiii1hv"
    t.integer "ttiii1hv_datatype",   :limit => 1
    t.string  "ttv"
    t.integer "ttv_datatype",        :limit => 1
    t.string  "ttvi"
    t.integer "ttvi_datatype",       :limit => 1
    t.string  "ttvihv"
    t.integer "ttvihv_datatype",     :limit => 1
    t.string  "ttvii"
    t.integer "ttvii_datatype",      :limit => 1
    t.string  "ttvii6"
    t.integer "ttvii6_datatype",     :limit => 1
    t.string  "ttvii7"
    t.integer "ttvii7_datatype",     :limit => 1
    t.string  "ttviii"
    t.integer "ttviii_datatype",     :limit => 1
    t.string  "ttix1hv"
    t.integer "ttix1hv_datatype",    :limit => 1
    t.string  "ttx1hv"
    t.integer "ttx1hv_datatype",     :limit => 1
    t.string  "ttxi1hv"
    t.integer "ttxi1hv_datatype",    :limit => 1
    t.string  "ttxii1"
    t.integer "ttxii1_datatype",     :limit => 1
    t.string  "ttxii2"
    t.integer "ttxii2_datatype",     :limit => 1
    t.string  "ttxii3"
    t.integer "ttxii3_datatype",     :limit => 1
    t.string  "ttxii4"
    t.integer "ttxii4_datatype",     :limit => 1
    t.string  "ttxii5"
    t.integer "ttxii5_datatype",     :limit => 1
    t.string  "ttxii6"
    t.integer "ttxii6_datatype",     :limit => 1
    t.string  "ttxii7"
    t.integer "ttxii7_datatype",     :limit => 1
    t.string  "ttxii8"
    t.integer "ttxii8_datatype",     :limit => 1
    t.string  "ttxii9"
    t.integer "ttxii9_datatype",     :limit => 1
    t.string  "ttxii9hv"
    t.integer "ttxii9hv_datatype",   :limit => 1
    t.string  "ttxii10"
    t.integer "ttxii10_datatype",    :limit => 1
    t.string  "ttxii11"
    t.integer "ttxii11_datatype",    :limit => 1
    t.string  "ttxii12"
    t.integer "ttxii12_datatype",    :limit => 1
    t.string  "ttxii13"
    t.integer "ttxii13_datatype",    :limit => 1
    t.string  "ttxii14"
    t.integer "ttxii14_datatype",    :limit => 1
    t.string  "ttxii15"
    t.integer "ttxii15_datatype",    :limit => 1
    t.string  "ttxii16"
    t.integer "ttxii16_datatype",    :limit => 1
    t.string  "ttxii17"
    t.integer "ttxii17_datatype",    :limit => 1
    t.string  "ttxii18"
    t.integer "ttxii18_datatype",    :limit => 1
    t.string  "ttxii19"
    t.integer "ttxii19_datatype",    :limit => 1
    t.string  "ttxii20"
    t.integer "ttxii20_datatype",    :limit => 1
    t.string  "ttxii21"
    t.integer "ttxii21_datatype",    :limit => 1
    t.string  "ttxii22"
    t.integer "ttxii22_datatype",    :limit => 1
    t.string  "ttxii23"
    t.integer "ttxii23_datatype",    :limit => 1
    t.string  "ttxii24"
    t.integer "ttxii24_datatype",    :limit => 1
    t.string  "ttxii25"
    t.integer "ttxii25_datatype",    :limit => 1
    t.string  "ttxii26"
    t.integer "ttxii26_datatype",    :limit => 1
    t.string  "ttxii27"
    t.integer "ttxii27_datatype",    :limit => 1
    t.string  "ttxii28"
    t.integer "ttxii28_datatype",    :limit => 1
    t.string  "ttxii29"
    t.integer "ttxii29_datatype",    :limit => 1
    t.string  "ttxii29hv"
    t.integer "ttxii29hv_datatype",  :limit => 1
    t.string  "ttxii30"
    t.integer "ttxii30_datatype",    :limit => 1
    t.string  "ttxii31"
    t.integer "ttxii31_datatype",    :limit => 1
    t.string  "ttxii32"
    t.integer "ttxii32_datatype",    :limit => 1
    t.string  "ttxii33"
    t.integer "ttxii33_datatype",    :limit => 1
    t.string  "ttxii34"
    t.integer "ttxii34_datatype",    :limit => 1
    t.string  "ttxii35"
    t.integer "ttxii35_datatype",    :limit => 1
    t.string  "ttxii36"
    t.integer "ttxii36_datatype",    :limit => 1
    t.string  "ttxii37"
    t.integer "ttxii37_datatype",    :limit => 1
    t.string  "ttxii38"
    t.integer "ttxii38_datatype",    :limit => 1
    t.string  "ttxii39"
    t.integer "ttxii39_datatype",    :limit => 1
    t.string  "ttxii40"
    t.integer "ttxii40_datatype",    :limit => 1
    t.string  "ttxii40hv"
    t.integer "ttxii40hv_datatype",  :limit => 1
    t.string  "ttxii41"
    t.integer "ttxii41_datatype",    :limit => 1
    t.string  "ttxii42"
    t.integer "ttxii42_datatype",    :limit => 1
    t.string  "ttxii43"
    t.integer "ttxii43_datatype",    :limit => 1
    t.string  "ttxii44"
    t.integer "ttxii44_datatype",    :limit => 1
    t.string  "ttxii45"
    t.integer "ttxii45_datatype",    :limit => 1
    t.string  "ttxii46"
    t.integer "ttxii46_datatype",    :limit => 1
    t.string  "ttxii46hv"
    t.integer "ttxii46hv_datatype",  :limit => 1
    t.string  "ttxii47"
    t.integer "ttxii47_datatype",    :limit => 1
    t.string  "ttxii48"
    t.integer "ttxii48_datatype",    :limit => 1
    t.string  "ttxii49"
    t.integer "ttxii49_datatype",    :limit => 1
    t.string  "ttxii50"
    t.integer "ttxii50_datatype",    :limit => 1
    t.string  "ttxii51"
    t.integer "ttxii51_datatype",    :limit => 1
    t.string  "ttxii52"
    t.integer "ttxii52_datatype",    :limit => 1
    t.string  "ttxii53"
    t.integer "ttxii53_datatype",    :limit => 1
    t.string  "ttxii54"
    t.integer "ttxii54_datatype",    :limit => 1
    t.string  "ttxii55"
    t.integer "ttxii55_datatype",    :limit => 1
    t.string  "ttxii56a"
    t.integer "ttxii56a_datatype",   :limit => 1
    t.string  "ttxii56b"
    t.integer "ttxii56b_datatype",   :limit => 1
    t.string  "ttxii56c"
    t.integer "ttxii56c_datatype",   :limit => 1
    t.string  "ttxii56d"
    t.integer "ttxii56d_datatype",   :limit => 1
    t.string  "ttxii56dhv"
    t.integer "ttxii56dhv_datatype", :limit => 1
    t.string  "ttxii56e"
    t.integer "ttxii56e_datatype",   :limit => 1
    t.string  "ttxii56f"
    t.integer "ttxii56f_datatype",   :limit => 1
    t.string  "ttxii56g"
    t.integer "ttxii56g_datatype",   :limit => 1
    t.string  "ttxii56h"
    t.integer "ttxii56h_datatype",   :limit => 1
    t.string  "ttxii56hhv"
    t.integer "ttxii56hhv_datatype", :limit => 1
    t.string  "ttxii57"
    t.integer "ttxii57_datatype",    :limit => 1
    t.string  "ttxii58"
    t.integer "ttxii58_datatype",    :limit => 1
    t.string  "ttxii58hv"
    t.integer "ttxii58hv_datatype",  :limit => 1
    t.string  "ttxii59"
    t.integer "ttxii59_datatype",    :limit => 1
    t.string  "ttxii60"
    t.integer "ttxii60_datatype",    :limit => 1
    t.string  "ttxii61"
    t.integer "ttxii61_datatype",    :limit => 1
    t.string  "ttxii62"
    t.integer "ttxii62_datatype",    :limit => 1
    t.string  "ttxii63"
    t.integer "ttxii63_datatype",    :limit => 1
    t.string  "ttxii64"
    t.integer "ttxii64_datatype",    :limit => 1
    t.string  "ttxii65"
    t.integer "ttxii65_datatype",    :limit => 1
    t.string  "ttxii66"
    t.integer "ttxii66_datatype",    :limit => 1
    t.string  "ttxii66hv"
    t.integer "ttxii66hv_datatype",  :limit => 1
    t.string  "ttxii67"
    t.integer "ttxii67_datatype",    :limit => 1
    t.string  "ttxii68"
    t.integer "ttxii68_datatype",    :limit => 1
    t.string  "ttxii69"
    t.integer "ttxii69_datatype",    :limit => 1
    t.string  "ttxii70"
    t.integer "ttxii70_datatype",    :limit => 1
    t.string  "ttxii70hv"
    t.integer "ttxii70hv_datatype",  :limit => 1
    t.string  "ttxii71"
    t.integer "ttxii71_datatype",    :limit => 1
    t.string  "ttxii72"
    t.integer "ttxii72_datatype",    :limit => 1
    t.string  "ttxii73"
    t.integer "ttxii73_datatype",    :limit => 1
    t.string  "ttxii73hv"
    t.integer "ttxii73hv_datatype",  :limit => 1
    t.string  "ttxii74"
    t.integer "ttxii74_datatype",    :limit => 1
    t.string  "ttxii75"
    t.integer "ttxii75_datatype",    :limit => 1
    t.string  "ttxii76"
    t.integer "ttxii76_datatype",    :limit => 1
    t.string  "ttxii77"
    t.integer "ttxii77_datatype",    :limit => 1
    t.string  "ttxii78"
    t.integer "ttxii78_datatype",    :limit => 1
    t.string  "ttxii79"
    t.integer "ttxii79_datatype",    :limit => 1
    t.string  "ttxii79hv"
    t.integer "ttxii79hv_datatype",  :limit => 1
    t.string  "ttxii80"
    t.integer "ttxii80_datatype",    :limit => 1
    t.string  "ttxii81"
    t.integer "ttxii81_datatype",    :limit => 1
    t.string  "ttxii82"
    t.integer "ttxii82_datatype",    :limit => 1
    t.string  "ttxii83"
    t.integer "ttxii83_datatype",    :limit => 1
    t.string  "ttxii83hv"
    t.integer "ttxii83hv_datatype",  :limit => 1
    t.string  "ttxii84"
    t.integer "ttxii84_datatype",    :limit => 1
    t.string  "ttxii84hv"
    t.integer "ttxii84hv_datatype",  :limit => 1
    t.string  "ttxii85"
    t.integer "ttxii85_datatype",    :limit => 1
    t.string  "ttxii85hv"
    t.integer "ttxii85hv_datatype",  :limit => 1
    t.string  "ttxii86"
    t.integer "ttxii86_datatype",    :limit => 1
    t.string  "ttxii87"
    t.integer "ttxii87_datatype",    :limit => 1
    t.string  "ttxii88"
    t.integer "ttxii88_datatype",    :limit => 1
    t.string  "ttxii89"
    t.integer "ttxii89_datatype",    :limit => 1
    t.string  "ttxii90"
    t.integer "ttxii90_datatype",    :limit => 1
    t.string  "ttxii91"
    t.integer "ttxii91_datatype",    :limit => 1
    t.string  "ttxii92"
    t.integer "ttxii92_datatype",    :limit => 1
    t.string  "ttxii93"
    t.integer "ttxii93_datatype",    :limit => 1
    t.string  "ttxii94"
    t.integer "ttxii94_datatype",    :limit => 1
    t.string  "ttxii95"
    t.integer "ttxii95_datatype",    :limit => 1
    t.string  "ttxii96"
    t.integer "ttxii96_datatype",    :limit => 1
    t.string  "ttxii97"
    t.integer "ttxii97_datatype",    :limit => 1
    t.string  "ttxii98"
    t.integer "ttxii98_datatype",    :limit => 1
    t.string  "ttxii99"
    t.integer "ttxii99_datatype",    :limit => 1
    t.string  "ttxii100"
    t.integer "ttxii100_datatype",   :limit => 1
    t.string  "ttxii101"
    t.integer "ttxii101_datatype",   :limit => 1
    t.string  "ttxii102"
    t.integer "ttxii102_datatype",   :limit => 1
    t.string  "ttxii103"
    t.integer "ttxii103_datatype",   :limit => 1
    t.string  "ttxii104"
    t.integer "ttxii104_datatype",   :limit => 1
    t.string  "ttxii105"
    t.integer "ttxii105_datatype",   :limit => 1
    t.string  "ttxii105hv"
    t.integer "ttxii105hv_datatype", :limit => 1
    t.string  "ttxii106"
    t.integer "ttxii106_datatype",   :limit => 1
    t.string  "ttxii107"
    t.integer "ttxii107_datatype",   :limit => 1
    t.string  "ttxii108"
    t.integer "ttxii108_datatype",   :limit => 1
    t.string  "ttxii109"
    t.integer "ttxii109_datatype",   :limit => 1
    t.string  "ttxii110"
    t.integer "ttxii110_datatype",   :limit => 1
    t.string  "ttxii111"
    t.integer "ttxii111_datatype",   :limit => 1
    t.string  "ttxii112"
    t.integer "ttxii112_datatype",   :limit => 1
    t.string  "ttxiihv"
    t.integer "ttxiihv_datatype",    :limit => 1
  end

  add_index "export_variables_survey_tt", ["journal_id"], :name => "index_export_variables_survey_tt_on_journal_id"

  create_table "export_variables_survey_ycy", :force => true do |t|
    t.integer "journal_id",            :limit => 3
    t.string  "ycyi"
    t.integer "ycyi_datatype",         :limit => 1
    t.string  "ycyi1a"
    t.integer "ycyi1a_datatype",       :limit => 1
    t.string  "ycyi1b"
    t.integer "ycyi1b_datatype",       :limit => 1
    t.string  "ycyi1c"
    t.integer "ycyi1c_datatype",       :limit => 1
    t.string  "ycyii"
    t.integer "ycyii_datatype",        :limit => 1
    t.string  "ycyii1a"
    t.integer "ycyii1a_datatype",      :limit => 1
    t.string  "ycyii1b"
    t.integer "ycyii1b_datatype",      :limit => 1
    t.string  "ycyii1c"
    t.integer "ycyii1c_datatype",      :limit => 1
    t.string  "ycyiii"
    t.integer "ycyiii_datatype",       :limit => 1
    t.string  "ycyiii1"
    t.integer "ycyiii1_datatype",      :limit => 1
    t.string  "ycyiii1b"
    t.integer "ycyiii1b_datatype",     :limit => 1
    t.string  "ycyiii1c"
    t.integer "ycyiii1c_datatype",     :limit => 1
    t.string  "ycyiv"
    t.integer "ycyiv_datatype",        :limit => 1
    t.string  "ycyiv1a"
    t.integer "ycyiv1a_datatype",      :limit => 1
    t.string  "ycyiv1b"
    t.integer "ycyiv1b_datatype",      :limit => 1
    t.string  "ycyiv1c"
    t.integer "ycyiv1c_datatype",      :limit => 1
    t.string  "ycyv1"
    t.integer "ycyv1_datatype",        :limit => 1
    t.string  "ycyv2"
    t.integer "ycyv2_datatype",        :limit => 1
    t.string  "ycyvi1a"
    t.integer "ycyvi1a_datatype",      :limit => 1
    t.string  "ycyvi1b"
    t.integer "ycyvi1b_datatype",      :limit => 1
    t.string  "ycyvi1c"
    t.integer "ycyvi1c_datatype",      :limit => 1
    t.string  "ycyvi1d"
    t.integer "ycyvi1d_datatype",      :limit => 1
    t.string  "ycyvii1a"
    t.integer "ycyvii1a_datatype",     :limit => 1
    t.string  "ycyvii1b"
    t.integer "ycyvii1b_datatype",     :limit => 1
    t.string  "ycyvii1c"
    t.integer "ycyvii1c_datatype",     :limit => 1
    t.string  "ycyvii1d"
    t.integer "ycyvii1d_datatype",     :limit => 1
    t.string  "ycyvii1e"
    t.integer "ycyvii1e_datatype",     :limit => 1
    t.string  "ycyvii1f"
    t.integer "ycyvii1f_datatype",     :limit => 1
    t.string  "ycyvii1g"
    t.integer "ycyvii1g_datatype",     :limit => 1
    t.string  "ycyviii1"
    t.integer "ycyviii1_datatype",     :limit => 1
    t.string  "ycyviii2"
    t.integer "ycyviii2_datatype",     :limit => 1
    t.string  "ycyviii2hv"
    t.integer "ycyviii2hv_datatype",   :limit => 1
    t.string  "ycyviii3"
    t.integer "ycyviii3_datatype",     :limit => 1
    t.string  "ycyviii4"
    t.integer "ycyviii4_datatype",     :limit => 1
    t.string  "ycyviii5"
    t.integer "ycyviii5_datatype",     :limit => 1
    t.string  "ycyviii6"
    t.integer "ycyviii6_datatype",     :limit => 1
    t.string  "ycyviii7"
    t.integer "ycyviii7_datatype",     :limit => 1
    t.string  "ycyviii8"
    t.integer "ycyviii8_datatype",     :limit => 1
    t.string  "ycyviii9"
    t.integer "ycyviii9_datatype",     :limit => 1
    t.string  "ycyviii9hv"
    t.integer "ycyviii9hv_datatype",   :limit => 1
    t.string  "ycyviii10"
    t.integer "ycyviii10_datatype",    :limit => 1
    t.string  "ycyviii11"
    t.integer "ycyviii11_datatype",    :limit => 1
    t.string  "ycyviii12"
    t.integer "ycyviii12_datatype",    :limit => 1
    t.string  "ycyviii13"
    t.integer "ycyviii13_datatype",    :limit => 1
    t.string  "ycyviii14"
    t.integer "ycyviii14_datatype",    :limit => 1
    t.string  "ycyviii15"
    t.integer "ycyviii15_datatype",    :limit => 1
    t.string  "ycyviii16"
    t.integer "ycyviii16_datatype",    :limit => 1
    t.string  "ycyviii17"
    t.integer "ycyviii17_datatype",    :limit => 1
    t.string  "ycyviii18"
    t.integer "ycyviii18_datatype",    :limit => 1
    t.string  "ycyviii19"
    t.integer "ycyviii19_datatype",    :limit => 1
    t.string  "ycyviii20"
    t.integer "ycyviii20_datatype",    :limit => 1
    t.string  "ycyviii21"
    t.integer "ycyviii21_datatype",    :limit => 1
    t.string  "ycyviii22"
    t.integer "ycyviii22_datatype",    :limit => 1
    t.string  "ycyviii23"
    t.integer "ycyviii23_datatype",    :limit => 1
    t.string  "ycyviii24"
    t.integer "ycyviii24_datatype",    :limit => 1
    t.string  "ycyviii25"
    t.integer "ycyviii25_datatype",    :limit => 1
    t.string  "ycyviii26"
    t.integer "ycyviii26_datatype",    :limit => 1
    t.string  "ycyviii27"
    t.integer "ycyviii27_datatype",    :limit => 1
    t.string  "ycyviii28"
    t.integer "ycyviii28_datatype",    :limit => 1
    t.string  "ycyviii29"
    t.integer "ycyviii29_datatype",    :limit => 1
    t.string  "ycyviii29hv"
    t.integer "ycyviii29hv_datatype",  :limit => 1
    t.string  "ycyviii30"
    t.integer "ycyviii30_datatype",    :limit => 1
    t.string  "ycyviii31"
    t.integer "ycyviii31_datatype",    :limit => 1
    t.string  "ycyviii32"
    t.integer "ycyviii32_datatype",    :limit => 1
    t.string  "ycyviii33"
    t.integer "ycyviii33_datatype",    :limit => 1
    t.string  "ycyviii34"
    t.integer "ycyviii34_datatype",    :limit => 1
    t.string  "ycyviii35"
    t.integer "ycyviii35_datatype",    :limit => 1
    t.string  "ycyviii36"
    t.integer "ycyviii36_datatype",    :limit => 1
    t.string  "ycyviii37"
    t.integer "ycyviii37_datatype",    :limit => 1
    t.string  "ycyviii38"
    t.integer "ycyviii38_datatype",    :limit => 1
    t.string  "ycyviii39"
    t.integer "ycyviii39_datatype",    :limit => 1
    t.string  "ycyviii40"
    t.integer "ycyviii40_datatype",    :limit => 1
    t.string  "ycyviii40hv"
    t.integer "ycyviii40hv_datatype",  :limit => 1
    t.string  "ycyviii41"
    t.integer "ycyviii41_datatype",    :limit => 1
    t.string  "ycyviii42"
    t.integer "ycyviii42_datatype",    :limit => 1
    t.string  "ycyviii43"
    t.integer "ycyviii43_datatype",    :limit => 1
    t.string  "ycyviii44"
    t.integer "ycyviii44_datatype",    :limit => 1
    t.string  "ycyviii45"
    t.integer "ycyviii45_datatype",    :limit => 1
    t.string  "ycyviii46"
    t.integer "ycyviii46_datatype",    :limit => 1
    t.string  "ycyviii46hv"
    t.integer "ycyviii46hv_datatype",  :limit => 1
    t.string  "ycyviii47"
    t.integer "ycyviii47_datatype",    :limit => 1
    t.string  "ycyviii48"
    t.integer "ycyviii48_datatype",    :limit => 1
    t.string  "ycyviii49"
    t.integer "ycyviii49_datatype",    :limit => 1
    t.string  "ycyviii50"
    t.integer "ycyviii50_datatype",    :limit => 1
    t.string  "ycyviii51"
    t.integer "ycyviii51_datatype",    :limit => 1
    t.string  "ycyviii52"
    t.integer "ycyviii52_datatype",    :limit => 1
    t.string  "ycyviii53"
    t.integer "ycyviii53_datatype",    :limit => 1
    t.string  "ycyviii54"
    t.integer "ycyviii54_datatype",    :limit => 1
    t.string  "ycyviii55"
    t.integer "ycyviii55_datatype",    :limit => 1
    t.string  "ycyviii56a"
    t.integer "ycyviii56a_datatype",   :limit => 1
    t.string  "ycyviii56b"
    t.integer "ycyviii56b_datatype",   :limit => 1
    t.string  "ycyviii56c"
    t.integer "ycyviii56c_datatype",   :limit => 1
    t.string  "ycyviii56d"
    t.integer "ycyviii56d_datatype",   :limit => 1
    t.string  "ycyviii56dhv"
    t.integer "ycyviii56dhv_datatype", :limit => 1
    t.string  "ycyviii56e"
    t.integer "ycyviii56e_datatype",   :limit => 1
    t.string  "ycyviii56f"
    t.integer "ycyviii56f_datatype",   :limit => 1
    t.string  "ycyviii56g"
    t.integer "ycyviii56g_datatype",   :limit => 1
    t.string  "ycyviii56h"
    t.integer "ycyviii56h_datatype",   :limit => 1
    t.string  "ycyviii56hhv"
    t.integer "ycyviii56hhv_datatype", :limit => 1
    t.string  "ycyviii57"
    t.integer "ycyviii57_datatype",    :limit => 1
    t.string  "ycyviii58"
    t.integer "ycyviii58_datatype",    :limit => 1
    t.string  "ycyviii58hv"
    t.integer "ycyviii58hv_datatype",  :limit => 1
    t.string  "ycyviii59"
    t.integer "ycyviii59_datatype",    :limit => 1
    t.string  "ycyviii60"
    t.integer "ycyviii60_datatype",    :limit => 1
    t.string  "ycyviii61"
    t.integer "ycyviii61_datatype",    :limit => 1
    t.string  "ycyviii62"
    t.integer "ycyviii62_datatype",    :limit => 1
    t.string  "ycyviii63"
    t.integer "ycyviii63_datatype",    :limit => 1
    t.string  "ycyviii64"
    t.integer "ycyviii64_datatype",    :limit => 1
    t.string  "ycyviii65"
    t.integer "ycyviii65_datatype",    :limit => 1
    t.string  "ycyviii66"
    t.integer "ycyviii66_datatype",    :limit => 1
    t.string  "ycyviii66hv"
    t.integer "ycyviii66hv_datatype",  :limit => 1
    t.string  "ycyviii67"
    t.integer "ycyviii67_datatype",    :limit => 1
    t.string  "ycyviii68"
    t.integer "ycyviii68_datatype",    :limit => 1
    t.string  "ycyviii69"
    t.integer "ycyviii69_datatype",    :limit => 1
    t.string  "ycyviii70"
    t.integer "ycyviii70_datatype",    :limit => 1
    t.string  "ycyviii70hv"
    t.integer "ycyviii70hv_datatype",  :limit => 1
    t.string  "ycyviii71"
    t.integer "ycyviii71_datatype",    :limit => 1
    t.string  "ycyviii72"
    t.integer "ycyviii72_datatype",    :limit => 1
    t.string  "ycyviii73"
    t.integer "ycyviii73_datatype",    :limit => 1
    t.string  "ycyviii74"
    t.integer "ycyviii74_datatype",    :limit => 1
    t.string  "ycyviii75"
    t.integer "ycyviii75_datatype",    :limit => 1
    t.string  "ycyviii76"
    t.integer "ycyviii76_datatype",    :limit => 1
    t.string  "ycyviii77"
    t.integer "ycyviii77_datatype",    :limit => 1
    t.string  "ycyviii78"
    t.integer "ycyviii78_datatype",    :limit => 1
    t.string  "ycyviii79"
    t.integer "ycyviii79_datatype",    :limit => 1
    t.string  "ycyviii79hv"
    t.integer "ycyviii79hv_datatype",  :limit => 1
    t.string  "ycyviii80"
    t.integer "ycyviii80_datatype",    :limit => 1
    t.string  "ycyviii81"
    t.integer "ycyviii81_datatype",    :limit => 1
    t.string  "ycyviii82"
    t.integer "ycyviii82_datatype",    :limit => 1
    t.string  "ycyviii83"
    t.integer "ycyviii83_datatype",    :limit => 1
    t.string  "ycyviii83hv"
    t.integer "ycyviii83hv_datatype",  :limit => 1
    t.string  "ycyviii84"
    t.integer "ycyviii84_datatype",    :limit => 1
    t.string  "ycyviii84hv"
    t.integer "ycyviii84hv_datatype",  :limit => 1
    t.string  "ycyviii85"
    t.integer "ycyviii85_datatype",    :limit => 1
    t.string  "ycyviii85hv"
    t.integer "ycyviii85hv_datatype",  :limit => 1
    t.string  "ycyviii86"
    t.integer "ycyviii86_datatype",    :limit => 1
    t.string  "ycyviii87"
    t.integer "ycyviii87_datatype",    :limit => 1
    t.string  "ycyviii88"
    t.integer "ycyviii88_datatype",    :limit => 1
    t.string  "ycyviii89"
    t.integer "ycyviii89_datatype",    :limit => 1
    t.string  "ycyviii90"
    t.integer "ycyviii90_datatype",    :limit => 1
    t.string  "ycyviii91"
    t.integer "ycyviii91_datatype",    :limit => 1
    t.string  "ycyviii92"
    t.integer "ycyviii92_datatype",    :limit => 1
    t.string  "ycyviii93"
    t.integer "ycyviii93_datatype",    :limit => 1
    t.string  "ycyviii94"
    t.integer "ycyviii94_datatype",    :limit => 1
    t.string  "ycyviii95"
    t.integer "ycyviii95_datatype",    :limit => 1
    t.string  "ycyviii96"
    t.integer "ycyviii96_datatype",    :limit => 1
    t.string  "ycyviii97"
    t.integer "ycyviii97_datatype",    :limit => 1
    t.string  "ycyviii98"
    t.integer "ycyviii98_datatype",    :limit => 1
    t.string  "ycyviii99"
    t.integer "ycyviii99_datatype",    :limit => 1
    t.string  "ycyviii100"
    t.integer "ycyviii100_datatype",   :limit => 1
    t.string  "ycyviii100hv"
    t.integer "ycyviii100hv_datatype", :limit => 1
    t.string  "ycyviii101"
    t.integer "ycyviii101_datatype",   :limit => 1
    t.string  "ycyviii102"
    t.integer "ycyviii102_datatype",   :limit => 1
    t.string  "ycyviii103"
    t.integer "ycyviii103_datatype",   :limit => 1
    t.string  "ycyviii104"
    t.integer "ycyviii104_datatype",   :limit => 1
    t.string  "ycyviii105"
    t.integer "ycyviii105_datatype",   :limit => 1
    t.string  "ycyviii105hv"
    t.integer "ycyviii105hv_datatype", :limit => 1
    t.string  "ycyviii106"
    t.integer "ycyviii106_datatype",   :limit => 1
    t.string  "ycyviii107"
    t.integer "ycyviii107_datatype",   :limit => 1
    t.string  "ycyviii108"
    t.integer "ycyviii108_datatype",   :limit => 1
    t.string  "ycyviii109"
    t.integer "ycyviii109_datatype",   :limit => 1
    t.string  "ycyviii110"
    t.integer "ycyviii110_datatype",   :limit => 1
    t.string  "ycyviii111"
    t.integer "ycyviii111_datatype",   :limit => 1
    t.string  "ycyviii112"
    t.integer "ycyviii112_datatype",   :limit => 1
  end

  add_index "export_variables_survey_ycy", ["journal_id"], :name => "index_export_variables_survey_ycy_on_journal_id"

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
    t.string  "var"
  end

  add_index "question_cells", ["question_id"], :name => "fk_question_cells_questions"

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
    t.string  "var"
    t.string  "item"
    t.integer "row"
    t.integer "col"
    t.integer "survey_id"
    t.integer "question_id"
    t.string  "datatype"
  end

  add_index "variables", ["question_id"], :name => "fk_variables_questions"
  add_index "variables", ["survey_id"], :name => "fk_variables_surveys"

end
