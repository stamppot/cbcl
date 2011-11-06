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

ActiveRecord::Schema.define(:version => 19) do

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

  create_table "export_files", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_journal_infos", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.integer  "pid"
    t.string   "ssghafd"
    t.string   "ssghnavn"
    t.string   "safdnavn"
    t.integer  "pkoen"
    t.integer  "palder"
    t.string   "pnation"
    t.datetime "dagsdato"
    t.datetime "pfoedt"
  end

  create_table "export_survey_answer_1", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.datetime "answered_on"
    t.integer  "cci1"
    t.integer  "cci2"
    t.integer  "cci3"
    t.integer  "cci4"
    t.integer  "cci5"
    t.integer  "cci6"
    t.integer  "cci7"
    t.integer  "cci8"
    t.integer  "cci9"
    t.integer  "cci10"
    t.integer  "cci11"
    t.integer  "cci12"
    t.integer  "cci13"
    t.integer  "cci14"
    t.integer  "cci15"
    t.integer  "cci16"
    t.integer  "cci17"
    t.integer  "cci18"
    t.integer  "cci19"
    t.integer  "cci20"
    t.integer  "cci21"
    t.integer  "cci22"
    t.integer  "cci23"
    t.integer  "cci24"
    t.string   "cci24hv"
    t.integer  "cci25"
    t.integer  "cci26"
    t.integer  "cci27"
    t.integer  "cci28"
    t.integer  "cci29"
    t.integer  "cci30"
    t.integer  "cci31"
    t.string   "cci31hv"
    t.integer  "cci32"
    t.string   "cci32hv"
    t.integer  "cci33"
    t.integer  "cci34"
    t.integer  "cci35"
    t.integer  "cci36"
    t.integer  "cci37"
    t.integer  "cci38"
    t.integer  "cci39"
    t.integer  "cci40"
    t.integer  "cci41"
    t.integer  "cci42"
    t.integer  "cci43"
    t.integer  "cci44"
    t.integer  "cci45"
    t.integer  "cci46"
    t.string   "cci46hv"
    t.integer  "cci47"
    t.integer  "cci48"
    t.integer  "cci49"
    t.integer  "cci50"
    t.integer  "cci51"
    t.integer  "cci52"
    t.integer  "cci53"
    t.integer  "cci54"
    t.string   "cci54hv"
    t.integer  "cci55"
    t.integer  "cci56"
    t.integer  "cci57"
    t.integer  "cci58"
    t.integer  "cci59"
    t.integer  "cci60"
    t.integer  "cci61"
    t.integer  "cci62"
    t.integer  "cci63"
    t.integer  "cci64"
    t.integer  "cci65"
    t.integer  "cci66"
    t.integer  "cci67"
    t.integer  "cci68"
    t.integer  "cci69"
    t.integer  "cci70"
    t.integer  "cci71"
    t.integer  "cci72"
    t.integer  "cci73"
    t.integer  "cci74"
    t.string   "cci74hv"
    t.integer  "cci75"
    t.integer  "cci76"
    t.string   "cci76hv"
    t.integer  "cci77"
    t.integer  "cci78"
    t.integer  "cci79"
    t.integer  "cci80"
    t.string   "cci80hv"
    t.integer  "cci81"
    t.integer  "cci82"
    t.integer  "cci83"
    t.integer  "cci84"
    t.integer  "cci85"
    t.integer  "cci86"
    t.integer  "cci87"
    t.integer  "cci88"
    t.integer  "cci89"
    t.integer  "cci90"
    t.integer  "cci91"
    t.integer  "cci92"
    t.string   "cci92hv"
    t.integer  "cci93"
    t.integer  "cci94"
    t.integer  "cci95"
    t.integer  "cci96"
    t.integer  "cci97"
    t.integer  "cci98"
    t.integer  "cci99"
    t.integer  "cci100"
    t.string   "cci100hv"
    t.integer  "ccii1"
    t.string   "cciihv"
    t.string   "ccii2hv"
    t.string   "ccii3hv"
    t.integer  "cciii1"
    t.string   "cciii2hv"
    t.integer  "cciii3"
    t.integer  "cciii4"
    t.string   "cciii4hv"
    t.integer  "cciii5"
    t.string   "cciii5hv"
    t.integer  "cciii7"
    t.string   "cciii6hv"
    t.string   "cciii7hv"
  end

  create_table "export_survey_answer_2", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.datetime "answered_on"
    t.string   "ccyi"
    t.integer  "ccyi1a"
    t.integer  "ccyi1b"
    t.integer  "ccyi1c"
    t.string   "ccyii"
    t.integer  "ccyii1a"
    t.integer  "ccyii1b"
    t.integer  "ccyii1c"
    t.string   "ccyiii"
    t.integer  "ccyiii1a"
    t.integer  "ccyiii1b"
    t.integer  "ccyiii1c"
    t.string   "ccyiv"
    t.integer  "ccyiv1a"
    t.integer  "ccyiv1b"
    t.integer  "ccyiv1c"
    t.string   "ccyv1"
    t.string   "ccyv2"
    t.integer  "ccyvi1a"
    t.integer  "ccyvi1b"
    t.integer  "ccyvi1c"
    t.integer  "ccyvi1d"
    t.string   "ccyvii"
    t.string   "ccyviihv"
    t.integer  "ccyvii1a"
    t.integer  "ccyvii1b"
    t.integer  "ccyvii1c"
    t.integer  "ccyvii1d"
    t.integer  "ccyvii1e"
    t.integer  "ccyvii1f"
    t.integer  "ccyvii1g"
    t.string   "ccyvii2"
    t.string   "ccyvii3"
    t.string   "ccyvii3hv"
    t.integer  "ccyvii4"
    t.string   "ccyvii4hv"
    t.integer  "ccyvii5"
    t.integer  "ccyviii1"
    t.string   "ccyviiihv"
    t.string   "ccyviii2hv"
    t.string   "ccyviii3hv"
    t.integer  "ccyx1"
    t.integer  "ccyx2"
    t.string   "ccyx2hv"
    t.integer  "ccyx3"
    t.integer  "ccyx4"
    t.integer  "ccyx5"
    t.integer  "ccyx6"
    t.integer  "ccyx7"
    t.integer  "ccyx8"
    t.integer  "ccyx9"
    t.string   "ccyx9hv"
    t.integer  "ccyx10"
    t.integer  "ccyx11"
    t.integer  "ccyx12"
    t.integer  "ccyx13"
    t.integer  "ccyx14"
    t.integer  "ccyx15"
    t.integer  "ccyx16"
    t.integer  "ccyx17"
    t.integer  "ccyx18"
    t.integer  "ccyx19"
    t.integer  "ccyx20"
    t.integer  "ccyx21"
    t.integer  "ccyx22"
    t.integer  "ccyx23"
    t.integer  "ccyx24"
    t.integer  "ccyx25"
    t.integer  "ccyx26"
    t.integer  "ccyx27"
    t.integer  "ccyx28"
    t.integer  "ccyx29"
    t.string   "ccyx29hv"
    t.integer  "ccyx30"
    t.integer  "ccyx31"
    t.integer  "ccyx32"
    t.integer  "ccyx33"
    t.integer  "ccyx34"
    t.integer  "ccyx35"
    t.integer  "ccyx36"
    t.integer  "ccyx37"
    t.integer  "ccyx38"
    t.integer  "ccyx39"
    t.integer  "ccyx40"
    t.string   "ccyx40hv"
    t.integer  "ccyx41"
    t.integer  "ccyx42"
    t.integer  "ccyx43"
    t.integer  "ccyx44"
    t.integer  "ccyx45"
    t.integer  "ccyx46"
    t.string   "ccyx46hv"
    t.integer  "ccyx47"
    t.integer  "ccyx48"
    t.integer  "ccyx49"
    t.integer  "ccyx50"
    t.integer  "ccyx51"
    t.integer  "ccyx52"
    t.integer  "ccyx53"
    t.integer  "ccyx54"
    t.integer  "ccyx55"
    t.integer  "ccyx56a"
    t.integer  "ccyx56b"
    t.integer  "ccyx56c"
    t.integer  "ccyx56d"
    t.string   "ccyx56dhv"
    t.integer  "ccyx56e"
    t.integer  "ccyx56f"
    t.integer  "ccyx56g"
    t.integer  "ccyx56h"
    t.string   "ccyx56hhv"
    t.integer  "ccyx57"
    t.integer  "ccyx58"
    t.string   "ccyx58hv"
    t.integer  "ccyx59"
    t.integer  "ccyx60"
    t.integer  "ccyx61"
    t.integer  "ccyx62"
    t.integer  "ccyx63"
    t.integer  "ccyx64"
    t.integer  "ccyx65"
    t.integer  "ccyx66"
    t.string   "ccyx66hv"
    t.integer  "ccyx67"
    t.integer  "ccyx68"
    t.integer  "ccyx69"
    t.integer  "ccyx70"
    t.string   "ccyx70hv"
    t.integer  "ccyx71"
    t.integer  "ccyx72"
    t.integer  "ccyx73"
    t.string   "ccyx73hv"
    t.integer  "ccyx74"
    t.integer  "ccyx75"
    t.integer  "ccyx76"
    t.integer  "ccyx77"
    t.string   "ccyx77hv"
    t.integer  "ccyx78"
    t.integer  "ccyx79"
    t.string   "ccyx79hv"
    t.integer  "ccyx80"
    t.integer  "ccyx81"
    t.integer  "ccyx82"
    t.integer  "ccyx83"
    t.string   "ccyx83hv"
    t.integer  "ccyx84"
    t.string   "ccyx84hv"
    t.integer  "ccyx85"
    t.string   "ccyx85hv"
    t.integer  "ccyx86"
    t.integer  "ccyx87"
    t.integer  "ccyx88"
    t.integer  "ccyx89"
    t.integer  "ccyx90"
    t.integer  "ccyx91"
    t.integer  "ccyx92"
    t.string   "ccyx92hv"
    t.integer  "ccyx93"
    t.integer  "ccyx94"
    t.integer  "ccyx95"
    t.integer  "ccyx96"
    t.integer  "ccyx97"
    t.integer  "ccyx98"
    t.integer  "ccyx99"
    t.integer  "ccyx100"
    t.string   "ccyx100hv"
    t.integer  "ccyx101"
    t.integer  "ccyx102"
    t.integer  "ccyx103"
    t.integer  "ccyx104"
    t.integer  "ccyx105"
    t.string   "ccyx105hv"
    t.integer  "ccyx106"
    t.integer  "ccyx107"
    t.integer  "ccyx108"
    t.integer  "ccyx109"
    t.integer  "ccyx110"
    t.integer  "ccyx111"
    t.integer  "ccyx112"
    t.string   "ccyxhv"
  end

  create_table "export_survey_answer_3", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.datetime "answered_on"
    t.string   "cti1hv"
    t.integer  "cti2"
    t.string   "cti2hv"
    t.string   "ctiihv"
    t.string   "ctiii1hv"
    t.string   "ctiv1hv"
    t.integer  "ctv1"
    t.integer  "ctvi1"
    t.string   "ctvi1hv"
    t.integer  "ctvii1"
    t.integer  "ctvii2"
    t.integer  "ctvii3"
    t.integer  "ctvii4"
    t.integer  "ctvii5"
    t.integer  "ctvii6"
    t.integer  "ctvii7"
    t.integer  "ctvii8"
    t.integer  "ctvii9"
    t.integer  "ctvii10"
    t.integer  "ctvii11"
    t.integer  "ctvii12"
    t.integer  "ctvii13"
    t.integer  "ctvii14"
    t.integer  "ctvii15"
    t.integer  "ctvii16"
    t.integer  "ctvii17"
    t.integer  "ctvii18"
    t.integer  "ctvii19"
    t.integer  "ctvii20"
    t.integer  "ctvii21"
    t.integer  "ctvii22"
    t.integer  "ctvii23"
    t.integer  "ctvii24"
    t.integer  "ctvii25"
    t.integer  "ctvii26"
    t.integer  "ctvii27"
    t.integer  "ctvii28"
    t.integer  "ctvii29"
    t.integer  "ctvii30"
    t.integer  "ctvii31"
    t.string   "ctvii31hv"
    t.integer  "ctvii32"
    t.string   "ctvii32hv"
    t.integer  "ctvii33"
    t.integer  "ctvii34"
    t.integer  "ctvii35"
    t.integer  "ctvii36"
    t.integer  "ctvii37"
    t.integer  "ctvii38"
    t.integer  "ctvii39"
    t.integer  "ctvii40"
    t.integer  "ctvii41"
    t.integer  "ctvii42"
    t.integer  "ctvii43"
    t.integer  "ctvii44"
    t.integer  "ctvii45"
    t.integer  "ctvii46"
    t.string   "ctvii46hv"
    t.integer  "ctvii47"
    t.integer  "ctvii48"
    t.integer  "ctvii49"
    t.integer  "ctvii50"
    t.integer  "ctvii51"
    t.integer  "ctvii52"
    t.integer  "ctvii53"
    t.integer  "ctvii54"
    t.string   "ctvii54hv"
    t.integer  "ctvii55"
    t.integer  "ctvii56"
    t.integer  "ctvii57"
    t.integer  "ctvii58"
    t.integer  "ctvii59"
    t.integer  "ctvii60"
    t.integer  "ctvii61"
    t.integer  "ctvii62"
    t.integer  "ctvii63"
    t.integer  "ctvii64"
    t.integer  "ctvii65"
    t.integer  "ctvii66"
    t.integer  "ctvii67"
    t.integer  "ctvii68"
    t.integer  "ctvii69"
    t.integer  "ctvii70"
    t.integer  "ctvii71"
    t.integer  "ctvii72"
    t.integer  "ctvii73"
    t.integer  "ctvii74"
    t.integer  "ctvii75"
    t.integer  "ctvii76"
    t.string   "ctvii76hv"
    t.integer  "ctvii77"
    t.integer  "ctvii78"
    t.integer  "ctvii79"
    t.integer  "ctvii80"
    t.string   "ctvii80hv"
    t.integer  "ctvii81"
    t.integer  "ctvii82"
    t.integer  "ctvii83"
    t.integer  "ctvii84"
    t.integer  "ctvii85"
    t.integer  "ctvii86"
    t.integer  "ctvii87"
    t.integer  "ctvii88"
    t.integer  "ctvii89"
    t.integer  "ctvii90"
    t.integer  "ctvii91"
    t.integer  "ctvii92"
    t.string   "ctvii92hv"
    t.integer  "ctvii93"
    t.integer  "ctvii94"
    t.integer  "ctvii95"
    t.integer  "ctvii96"
    t.integer  "ctvii97"
    t.integer  "ctvii98"
    t.integer  "ctvii99"
    t.integer  "ctvii100"
    t.string   "ctvii100hv"
    t.integer  "ctviii1"
    t.string   "ctviii1hv"
    t.string   "ctviii2hv"
    t.string   "ctviii3hv"
  end

  create_table "export_survey_answer_4", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.datetime "answered_on"
    t.string   "tt"
    t.string   "tthv"
    t.integer  "ttii1"
    t.string   "ttiii1hv"
    t.string   "ttv"
    t.string   "ttvi"
    t.string   "ttvihv"
    t.integer  "ttvii"
    t.string   "ttvii6"
    t.string   "ttvii7"
    t.integer  "ttviii"
    t.string   "ttix1hv"
    t.string   "ttx1hv"
    t.string   "ttxi1hv"
    t.integer  "ttxii1"
    t.integer  "ttxii2"
    t.integer  "ttxii3"
    t.integer  "ttxii4"
    t.integer  "ttxii5"
    t.integer  "ttxii6"
    t.integer  "ttxii7"
    t.integer  "ttxii8"
    t.integer  "ttxii9"
    t.string   "ttxii9hv"
    t.integer  "ttxii10"
    t.integer  "ttxii11"
    t.integer  "ttxii12"
    t.integer  "ttxii13"
    t.integer  "ttxii14"
    t.integer  "ttxii15"
    t.integer  "ttxii16"
    t.integer  "ttxii17"
    t.integer  "ttxii18"
    t.integer  "ttxii19"
    t.integer  "ttxii20"
    t.integer  "ttxii21"
    t.integer  "ttxii22"
    t.integer  "ttxii23"
    t.integer  "ttxii24"
    t.integer  "ttxii25"
    t.integer  "ttxii26"
    t.integer  "ttxii27"
    t.integer  "ttxii28"
    t.integer  "ttxii29"
    t.string   "ttxii29hv"
    t.integer  "ttxii30"
    t.integer  "ttxii31"
    t.integer  "ttxii32"
    t.integer  "ttxii33"
    t.integer  "ttxii34"
    t.integer  "ttxii35"
    t.integer  "ttxii36"
    t.integer  "ttxii37"
    t.integer  "ttxii38"
    t.integer  "ttxii39"
    t.integer  "ttxii40"
    t.string   "ttxii40hv"
    t.integer  "ttxii41"
    t.integer  "ttxii42"
    t.integer  "ttxii43"
    t.integer  "ttxii44"
    t.integer  "ttxii45"
    t.integer  "ttxii46"
    t.string   "ttxii46hv"
    t.integer  "ttxii47"
    t.integer  "ttxii48"
    t.integer  "ttxii49"
    t.integer  "ttxii50"
    t.integer  "ttxii51"
    t.integer  "ttxii52"
    t.integer  "ttxii53"
    t.integer  "ttxii54"
    t.integer  "ttxii55"
    t.integer  "ttxii56a"
    t.integer  "ttxii56b"
    t.integer  "ttxii56c"
    t.integer  "ttxii56d"
    t.string   "ttxii56dhv"
    t.integer  "ttxii56e"
    t.integer  "ttxii56f"
    t.integer  "ttxii56g"
    t.integer  "ttxii56h"
    t.string   "ttxii56hhv"
    t.integer  "ttxii57"
    t.integer  "ttxii58"
    t.string   "ttxii58hv"
    t.integer  "ttxii59"
    t.integer  "ttxii60"
    t.integer  "ttxii61"
    t.integer  "ttxii62"
    t.integer  "ttxii63"
    t.integer  "ttxii64"
    t.integer  "ttxii65"
    t.integer  "ttxii66"
    t.string   "ttxii66hv"
    t.integer  "ttxii67"
    t.integer  "ttxii68"
    t.integer  "ttxii69"
    t.integer  "ttxii70"
    t.string   "ttxii70hv"
    t.integer  "ttxii71"
    t.integer  "ttxii72"
    t.integer  "ttxii73"
    t.string   "ttxii73hv"
    t.integer  "ttxii74"
    t.integer  "ttxii75"
    t.integer  "ttxii76"
    t.integer  "ttxii77"
    t.integer  "ttxii78"
    t.integer  "ttxii79"
    t.string   "ttxii79hv"
    t.integer  "ttxii80"
    t.integer  "ttxii81"
    t.integer  "ttxii82"
    t.integer  "ttxii83"
    t.string   "ttxii83hv"
    t.integer  "ttxii84"
    t.string   "ttxii84hv"
    t.integer  "ttxii85"
    t.string   "ttxii85hv"
    t.integer  "ttxii86"
    t.integer  "ttxii87"
    t.integer  "ttxii88"
    t.integer  "ttxii89"
    t.integer  "ttxii90"
    t.integer  "ttxii91"
    t.integer  "ttxii92"
    t.integer  "ttxii93"
    t.integer  "ttxii94"
    t.integer  "ttxii95"
    t.integer  "ttxii96"
    t.integer  "ttxii97"
    t.integer  "ttxii98"
    t.integer  "ttxii99"
    t.integer  "ttxii100"
    t.integer  "ttxii101"
    t.integer  "ttxii102"
    t.integer  "ttxii103"
    t.integer  "ttxii104"
    t.integer  "ttxii105"
    t.string   "ttxii105hv"
    t.integer  "ttxii106"
    t.integer  "ttxii107"
    t.integer  "ttxii108"
    t.integer  "ttxii109"
    t.integer  "ttxii110"
    t.integer  "ttxii111"
    t.integer  "ttxii112"
    t.string   "ttxiihv"
  end

  create_table "export_survey_answer_5", :force => true do |t|
    t.integer  "survey_answer_id"
    t.integer  "journal_entry_id"
    t.integer  "journal_id"
    t.integer  "center_id"
    t.datetime "answered_on"
    t.string   "ycyi"
    t.integer  "ycyi1a"
    t.integer  "ycyi1b"
    t.integer  "ycyi1c"
    t.string   "ycyii"
    t.integer  "ycyii1a"
    t.integer  "ycyii1b"
    t.integer  "ycyii1c"
    t.string   "ycyiii"
    t.integer  "ycyiii1"
    t.integer  "ycyiii1b"
    t.integer  "ycyiii1c"
    t.string   "ycyiv"
    t.integer  "ycyiv1a"
    t.integer  "ycyiv1b"
    t.integer  "ycyiv1c"
    t.string   "ycyv1"
    t.string   "ycyv2"
    t.integer  "ycyvi1a"
    t.integer  "ycyvi1b"
    t.integer  "ycyvi1c"
    t.integer  "ycyvi1d"
    t.integer  "ycyvii1a"
    t.integer  "ycyvii1b"
    t.integer  "ycyvii1c"
    t.integer  "ycyvii1d"
    t.integer  "ycyvii1e"
    t.integer  "ycyvii1f"
    t.integer  "ycyvii1g"
    t.integer  "ycyviii1"
    t.integer  "ycyviii2"
    t.string   "ycyviii2hv"
    t.integer  "ycyviii3"
    t.integer  "ycyviii4"
    t.integer  "ycyviii5"
    t.integer  "ycyviii6"
    t.integer  "ycyviii7"
    t.integer  "ycyviii8"
    t.integer  "ycyviii9"
    t.string   "ycyviii9hv"
    t.integer  "ycyviii10"
    t.integer  "ycyviii11"
    t.integer  "ycyviii12"
    t.integer  "ycyviii13"
    t.integer  "ycyviii14"
    t.integer  "ycyviii15"
    t.integer  "ycyviii16"
    t.integer  "ycyviii17"
    t.integer  "ycyviii18"
    t.integer  "ycyviii19"
    t.integer  "ycyviii20"
    t.integer  "ycyviii21"
    t.integer  "ycyviii22"
    t.integer  "ycyviii23"
    t.integer  "ycyviii24"
    t.integer  "ycyviii25"
    t.integer  "ycyviii26"
    t.integer  "ycyviii27"
    t.integer  "ycyviii28"
    t.integer  "ycyviii29"
    t.string   "ycyviii29hv"
    t.integer  "ycyviii30"
    t.integer  "ycyviii31"
    t.integer  "ycyviii32"
    t.integer  "ycyviii33"
    t.integer  "ycyviii34"
    t.integer  "ycyviii35"
    t.integer  "ycyviii36"
    t.integer  "ycyviii37"
    t.integer  "ycyviii38"
    t.integer  "ycyviii39"
    t.integer  "ycyviii40"
    t.string   "ycyviii40hv"
    t.integer  "ycyviii41"
    t.integer  "ycyviii42"
    t.integer  "ycyviii43"
    t.integer  "ycyviii44"
    t.integer  "ycyviii45"
    t.integer  "ycyviii46"
    t.string   "ycyviii46hv"
    t.integer  "ycyviii47"
    t.integer  "ycyviii48"
    t.integer  "ycyviii49"
    t.integer  "ycyviii50"
    t.integer  "ycyviii51"
    t.integer  "ycyviii52"
    t.integer  "ycyviii53"
    t.integer  "ycyviii54"
    t.integer  "ycyviii55"
    t.integer  "ycyviii56a"
    t.integer  "ycyviii56b"
    t.integer  "ycyviii56c"
    t.integer  "ycyviii56d"
    t.string   "ycyviii56dhv"
    t.integer  "ycyviii56e"
    t.integer  "ycyviii56f"
    t.integer  "ycyviii56g"
    t.integer  "ycyviii56h"
    t.string   "ycyviii56hhv"
    t.integer  "ycyviii57"
    t.integer  "ycyviii58"
    t.string   "ycyviii58hv"
    t.integer  "ycyviii59"
    t.integer  "ycyviii60"
    t.integer  "ycyviii61"
    t.integer  "ycyviii62"
    t.integer  "ycyviii63"
    t.integer  "ycyviii64"
    t.integer  "ycyviii65"
    t.integer  "ycyviii66"
    t.string   "ycyviii66hv"
    t.integer  "ycyviii67"
    t.integer  "ycyviii68"
    t.integer  "ycyviii69"
    t.integer  "ycyviii70"
    t.string   "ycyviii70hv"
    t.integer  "ycyviii71"
    t.integer  "ycyviii72"
    t.integer  "ycyviii73"
    t.integer  "ycyviii74"
    t.integer  "ycyviii75"
    t.integer  "ycyviii76"
    t.integer  "ycyviii77"
    t.integer  "ycyviii78"
    t.integer  "ycyviii79"
    t.string   "ycyviii79hv"
    t.integer  "ycyviii80"
    t.integer  "ycyviii81"
    t.integer  "ycyviii82"
    t.integer  "ycyviii83"
    t.string   "ycyviii83hv"
    t.integer  "ycyviii84"
    t.string   "ycyviii84hv"
    t.integer  "ycyviii85"
    t.string   "ycyviii85hv"
    t.integer  "ycyviii86"
    t.integer  "ycyviii87"
    t.integer  "ycyviii88"
    t.integer  "ycyviii89"
    t.integer  "ycyviii90"
    t.integer  "ycyviii91"
    t.integer  "ycyviii92"
    t.integer  "ycyviii93"
    t.integer  "ycyviii94"
    t.integer  "ycyviii95"
    t.integer  "ycyviii96"
    t.integer  "ycyviii97"
    t.integer  "ycyviii98"
    t.integer  "ycyviii99"
    t.integer  "ycyviii100"
    t.string   "ycyviii100hv"
    t.integer  "ycyviii101"
    t.integer  "ycyviii102"
    t.integer  "ycyviii103"
    t.integer  "ycyviii104"
    t.integer  "ycyviii105"
    t.string   "ycyviii105hv"
    t.integer  "ycyviii106"
    t.integer  "ycyviii107"
    t.integer  "ycyviii108"
    t.integer  "ycyviii109"
    t.integer  "ycyviii110"
    t.integer  "ycyviii111"
    t.integer  "ycyviii112"
  end

  create_table "export_variables_survey_cc", :force => true do |t|
    t.integer "journal_id",          :limit => 3
    t.integer "cc1",                 :limit => 1
    t.integer "cc1_datatype",        :limit => 1
    t.integer "cc2",                 :limit => 1
    t.integer "cc2_datatype",        :limit => 1
    t.integer "cc3",                 :limit => 1
    t.integer "cc3_datatype",        :limit => 1
    t.integer "cc4",                 :limit => 1
    t.integer "cc4_datatype",        :limit => 1
    t.integer "cc5",                 :limit => 1
    t.integer "cc5_datatype",        :limit => 1
    t.integer "cc6",                 :limit => 1
    t.integer "cc6_datatype",        :limit => 1
    t.integer "cc7",                 :limit => 1
    t.integer "cc7_datatype",        :limit => 1
    t.integer "cc8",                 :limit => 1
    t.integer "cc8_datatype",        :limit => 1
    t.integer "cc9",                 :limit => 1
    t.integer "cc9_datatype",        :limit => 1
    t.integer "cc10",                :limit => 1
    t.integer "cc10_datatype",       :limit => 1
    t.integer "cc11",                :limit => 1
    t.integer "cc11_datatype",       :limit => 1
    t.integer "cc12",                :limit => 1
    t.integer "cc12_datatype",       :limit => 1
    t.integer "cc13",                :limit => 1
    t.integer "cc13_datatype",       :limit => 1
    t.integer "cc14",                :limit => 1
    t.integer "cc14_datatype",       :limit => 1
    t.integer "cc15",                :limit => 1
    t.integer "cc15_datatype",       :limit => 1
    t.integer "cc16",                :limit => 1
    t.integer "cc16_datatype",       :limit => 1
    t.integer "cc17",                :limit => 1
    t.integer "cc17_datatype",       :limit => 1
    t.integer "cc18",                :limit => 1
    t.integer "cc18_datatype",       :limit => 1
    t.integer "cc19",                :limit => 1
    t.integer "cc19_datatype",       :limit => 1
    t.integer "cc20",                :limit => 1
    t.integer "cc20_datatype",       :limit => 1
    t.integer "cc21",                :limit => 1
    t.integer "cc21_datatype",       :limit => 1
    t.integer "cc22",                :limit => 1
    t.integer "cc22_datatype",       :limit => 1
    t.integer "cc23",                :limit => 1
    t.integer "cc23_datatype",       :limit => 1
    t.integer "cc24",                :limit => 1
    t.integer "cc24_datatype",       :limit => 1
    t.string  "cc24hv"
    t.integer "cc24hv_datatype",     :limit => 1
    t.integer "cc25",                :limit => 1
    t.integer "cc25_datatype",       :limit => 1
    t.integer "cc26",                :limit => 1
    t.integer "cc26_datatype",       :limit => 1
    t.integer "cc27",                :limit => 1
    t.integer "cc27_datatype",       :limit => 1
    t.integer "cc28",                :limit => 1
    t.integer "cc28_datatype",       :limit => 1
    t.integer "cc29",                :limit => 1
    t.integer "cc29_datatype",       :limit => 1
    t.integer "cc30",                :limit => 1
    t.integer "cc30_datatype",       :limit => 1
    t.integer "cc31",                :limit => 1
    t.integer "cc31_datatype",       :limit => 1
    t.string  "cc31hv"
    t.integer "cc31hv_datatype",     :limit => 1
    t.integer "cc32",                :limit => 1
    t.integer "cc32_datatype",       :limit => 1
    t.string  "cc32hv"
    t.integer "cc32hv_datatype",     :limit => 1
    t.integer "cc33",                :limit => 1
    t.integer "cc33_datatype",       :limit => 1
    t.integer "cc34",                :limit => 1
    t.integer "cc34_datatype",       :limit => 1
    t.integer "cc35",                :limit => 1
    t.integer "cc35_datatype",       :limit => 1
    t.integer "cc36",                :limit => 1
    t.integer "cc36_datatype",       :limit => 1
    t.integer "cc37",                :limit => 1
    t.integer "cc37_datatype",       :limit => 1
    t.integer "cc38",                :limit => 1
    t.integer "cc38_datatype",       :limit => 1
    t.integer "cc39",                :limit => 1
    t.integer "cc39_datatype",       :limit => 1
    t.integer "cc40",                :limit => 1
    t.integer "cc40_datatype",       :limit => 1
    t.integer "cc41",                :limit => 1
    t.integer "cc41_datatype",       :limit => 1
    t.integer "cc42",                :limit => 1
    t.integer "cc42_datatype",       :limit => 1
    t.integer "cc43",                :limit => 1
    t.integer "cc43_datatype",       :limit => 1
    t.integer "cc44",                :limit => 1
    t.integer "cc44_datatype",       :limit => 1
    t.integer "cc45",                :limit => 1
    t.integer "cc45_datatype",       :limit => 1
    t.integer "cc46",                :limit => 1
    t.integer "cc46_datatype",       :limit => 1
    t.string  "cc46hv"
    t.integer "cc46hv_datatype",     :limit => 1
    t.integer "cc47",                :limit => 1
    t.integer "cc47_datatype",       :limit => 1
    t.integer "cc48",                :limit => 1
    t.integer "cc48_datatype",       :limit => 1
    t.integer "cc49",                :limit => 1
    t.integer "cc49_datatype",       :limit => 1
    t.integer "cc50",                :limit => 1
    t.integer "cc50_datatype",       :limit => 1
    t.integer "cc51",                :limit => 1
    t.integer "cc51_datatype",       :limit => 1
    t.integer "cc52",                :limit => 1
    t.integer "cc52_datatype",       :limit => 1
    t.integer "cc53",                :limit => 1
    t.integer "cc53_datatype",       :limit => 1
    t.integer "cc54",                :limit => 1
    t.integer "cc54_datatype",       :limit => 1
    t.string  "cc54hv"
    t.integer "cc54hv_datatype",     :limit => 1
    t.integer "cc55",                :limit => 1
    t.integer "cc55_datatype",       :limit => 1
    t.integer "cc56",                :limit => 1
    t.integer "cc56_datatype",       :limit => 1
    t.integer "cc57",                :limit => 1
    t.integer "cc57_datatype",       :limit => 1
    t.integer "cc58",                :limit => 1
    t.integer "cc58_datatype",       :limit => 1
    t.integer "cc59",                :limit => 1
    t.integer "cc59_datatype",       :limit => 1
    t.integer "cc60",                :limit => 1
    t.integer "cc60_datatype",       :limit => 1
    t.integer "cc61",                :limit => 1
    t.integer "cc61_datatype",       :limit => 1
    t.integer "cc62",                :limit => 1
    t.integer "cc62_datatype",       :limit => 1
    t.integer "cc63",                :limit => 1
    t.integer "cc63_datatype",       :limit => 1
    t.integer "cc64",                :limit => 1
    t.integer "cc64_datatype",       :limit => 1
    t.integer "cc65",                :limit => 1
    t.integer "cc65_datatype",       :limit => 1
    t.integer "cc66",                :limit => 1
    t.integer "cc66_datatype",       :limit => 1
    t.integer "cc67",                :limit => 1
    t.integer "cc67_datatype",       :limit => 1
    t.integer "cc68",                :limit => 1
    t.integer "cc68_datatype",       :limit => 1
    t.integer "cc69",                :limit => 1
    t.integer "cc69_datatype",       :limit => 1
    t.integer "cc70",                :limit => 1
    t.integer "cc70_datatype",       :limit => 1
    t.integer "cc71",                :limit => 1
    t.integer "cc71_datatype",       :limit => 1
    t.integer "cc72",                :limit => 1
    t.integer "cc72_datatype",       :limit => 1
    t.integer "cc73",                :limit => 1
    t.integer "cc73_datatype",       :limit => 1
    t.integer "cc74",                :limit => 1
    t.integer "cc74_datatype",       :limit => 1
    t.string  "cc74hv"
    t.integer "cc74hv_datatype",     :limit => 1
    t.integer "cc75",                :limit => 1
    t.integer "cc75_datatype",       :limit => 1
    t.integer "cc76",                :limit => 1
    t.integer "cc76_datatype",       :limit => 1
    t.string  "cc76hv"
    t.integer "cc76hv_datatype",     :limit => 1
    t.integer "cc77",                :limit => 1
    t.integer "cc77_datatype",       :limit => 1
    t.integer "cc78",                :limit => 1
    t.integer "cc78_datatype",       :limit => 1
    t.integer "cc79",                :limit => 1
    t.integer "cc79_datatype",       :limit => 1
    t.integer "cc80",                :limit => 1
    t.integer "cc80_datatype",       :limit => 1
    t.string  "cc80hv"
    t.integer "cc80hv_datatype",     :limit => 1
    t.integer "cc81",                :limit => 1
    t.integer "cc81_datatype",       :limit => 1
    t.integer "cc82",                :limit => 1
    t.integer "cc82_datatype",       :limit => 1
    t.integer "cc83",                :limit => 1
    t.integer "cc83_datatype",       :limit => 1
    t.integer "cc84",                :limit => 1
    t.integer "cc84_datatype",       :limit => 1
    t.integer "cc85",                :limit => 1
    t.integer "cc85_datatype",       :limit => 1
    t.integer "cc86",                :limit => 1
    t.integer "cc86_datatype",       :limit => 1
    t.integer "cc87",                :limit => 1
    t.integer "cc87_datatype",       :limit => 1
    t.integer "cc88",                :limit => 1
    t.integer "cc88_datatype",       :limit => 1
    t.integer "cc89",                :limit => 1
    t.integer "cc89_datatype",       :limit => 1
    t.integer "cc90",                :limit => 1
    t.integer "cc90_datatype",       :limit => 1
    t.integer "cc91",                :limit => 1
    t.integer "cc91_datatype",       :limit => 1
    t.integer "cc92",                :limit => 1
    t.integer "cc92_datatype",       :limit => 1
    t.string  "cc92hv"
    t.integer "cc92hv_datatype",     :limit => 1
    t.integer "cc93",                :limit => 1
    t.integer "cc93_datatype",       :limit => 1
    t.integer "cc94",                :limit => 1
    t.integer "cc94_datatype",       :limit => 1
    t.integer "cc95",                :limit => 1
    t.integer "cc95_datatype",       :limit => 1
    t.integer "cc96",                :limit => 1
    t.integer "cc96_datatype",       :limit => 1
    t.integer "cc97",                :limit => 1
    t.integer "cc97_datatype",       :limit => 1
    t.integer "cc98",                :limit => 1
    t.integer "cc98_datatype",       :limit => 1
    t.integer "cc99",                :limit => 1
    t.integer "cc99_datatype",       :limit => 1
    t.integer "cc100",               :limit => 1
    t.integer "cc100_datatype",      :limit => 1
    t.string  "cc100hv"
    t.integer "cc100hv_datatype",    :limit => 1
    t.integer "cchandic",            :limit => 1
    t.integer "cchandic_datatype",   :limit => 1
    t.integer "cchandhv",            :limit => 1
    t.integer "cchandhv_datatype",   :limit => 1
    t.string  "ccbekyhv"
    t.integer "ccbekyhv_datatype",   :limit => 1
    t.string  "ccbedshv"
    t.integer "ccbedshv_datatype",   :limit => 1
    t.integer "ccfodtid",            :limit => 1
    t.integer "ccfodtid_datatype",   :limit => 1
    t.integer "ccfodg",              :limit => 1
    t.integer "ccfodg_datatype",     :limit => 1
    t.integer "ccorebet",            :limit => 1
    t.integer "ccorebet_datatype",   :limit => 1
    t.integer "ccsproan",            :limit => 1
    t.integer "ccsproan_datatype",   :limit => 1
    t.string  "ccsprohv"
    t.integer "ccsprohv_datatype",   :limit => 1
    t.integer "cctale",              :limit => 1
    t.integer "cctale_datatype",     :limit => 1
    t.integer "cctalehv",            :limit => 1
    t.integer "cctalehv_datatype",   :limit => 1
    t.integer "ccsprobe",            :limit => 1
    t.integer "ccsprobe_datatype",   :limit => 1
    t.string  "ccsprobehv"
    t.integer "ccsprobehv_datatype", :limit => 1
    t.string  "ccudvian"
    t.integer "ccudvian_datatype",   :limit => 1
    t.integer "ccfoduge",            :limit => 1
    t.integer "ccfoduge_datatype",   :limit => 1
  end

  add_index "export_variables_survey_cc", ["journal_id"], :name => "index_export_variables_survey_cc_on_journal_id"

  create_table "export_variables_survey_ccy", :force => true do |t|
    t.integer "journal_id",          :limit => 3
    t.integer "ccyispor",            :limit => 1
    t.integer "ccyispor_datatype",   :limit => 1
    t.integer "ccyiaspg",            :limit => 1
    t.integer "ccyiaspg_datatype",   :limit => 1
    t.integer "ccyibspg",            :limit => 1
    t.integer "ccyibspg_datatype",   :limit => 1
    t.integer "ccyicspg",            :limit => 1
    t.integer "ccyicspg_datatype",   :limit => 1
    t.integer "ccyiihob",            :limit => 1
    t.integer "ccyiihob_datatype",   :limit => 1
    t.integer "ccyiiahg",            :limit => 1
    t.integer "ccyiiahg_datatype",   :limit => 1
    t.integer "ccyiibhg",            :limit => 1
    t.integer "ccyiibhg_datatype",   :limit => 1
    t.integer "ccyiichg",            :limit => 1
    t.integer "ccyiichg_datatype",   :limit => 1
    t.integer "ccyiiifo",            :limit => 1
    t.integer "ccyiiifo_datatype",   :limit => 1
    t.integer "ccyiiia",             :limit => 1
    t.integer "ccyiiia_datatype",    :limit => 1
    t.integer "ccyiiib",             :limit => 1
    t.integer "ccyiiib_datatype",    :limit => 1
    t.integer "ccyiiic",             :limit => 1
    t.integer "ccyiiic_datatype",    :limit => 1
    t.integer "ccyivjob",            :limit => 1
    t.integer "ccyivjob_datatype",   :limit => 1
    t.integer "ccyivjag",            :limit => 1
    t.integer "ccyivjag_datatype",   :limit => 1
    t.integer "ccyivjbg",            :limit => 1
    t.integer "ccyivjbg_datatype",   :limit => 1
    t.integer "ccyivjcg",            :limit => 1
    t.integer "ccyivjcg_datatype",   :limit => 1
    t.integer "ccyv1ven",            :limit => 1
    t.integer "ccyv1ven_datatype",   :limit => 1
    t.integer "ccyv2vea",            :limit => 1
    t.integer "ccyv2vea_datatype",   :limit => 1
    t.integer "ccyvisos",            :limit => 1
    t.integer "ccyvisos_datatype",   :limit => 1
    t.integer "ccyvibor",            :limit => 1
    t.integer "ccyvibor_datatype",   :limit => 1
    t.integer "ccyvifor",            :limit => 1
    t.integer "ccyvifor_datatype",   :limit => 1
    t.integer "ccyviale",            :limit => 1
    t.integer "ccyviale_datatype",   :limit => 1
    t.integer "ccyviisko",           :limit => 1
    t.integer "ccyviisko_datatype",  :limit => 1
    t.string  "ccyviiund"
    t.integer "ccyviiund_datatype",  :limit => 1
    t.integer "caviilae",            :limit => 1
    t.integer "caviilae_datatype",   :limit => 1
    t.integer "caviista",            :limit => 1
    t.integer "caviista_datatype",   :limit => 1
    t.integer "caviimat",            :limit => 1
    t.integer "caviimat_datatype",   :limit => 1
    t.integer "caviinat",            :limit => 1
    t.integer "caviinat_datatype",   :limit => 1
    t.integer "caviieng",            :limit => 1
    t.integer "caviieng_datatype",   :limit => 1
    t.integer "caviivu1",            :limit => 1
    t.integer "caviivu1_datatype",   :limit => 1
    t.integer "caviivu2",            :limit => 1
    t.integer "caviivu2_datatype",   :limit => 1
    t.integer "ctcundty",            :limit => 1
    t.integer "ctcundty_datatype",   :limit => 1
    t.integer "ctcgomkl",            :limit => 1
    t.integer "ctcgomkl_datatype",   :limit => 1
    t.string  "ctcgomhv"
    t.integer "ctcgomhv_datatype",   :limit => 1
    t.integer "ccyvii4pr",           :limit => 1
    t.integer "ccyvii4pr_datatype",  :limit => 1
    t.string  "ccyvii4hv"
    t.integer "ccyvii4hv_datatype",  :limit => 1
    t.integer "ccyvii4ho",           :limit => 1
    t.integer "ccyvii4ho_datatype",  :limit => 1
    t.integer "ccyhandi",            :limit => 1
    t.integer "ccyhandi_datatype",   :limit => 1
    t.string  "ccyhandhv"
    t.integer "ccyhandhv_datatype",  :limit => 1
    t.string  "ccyviii2hv"
    t.integer "ccyviii2hv_datatype", :limit => 1
    t.string  "ccyviii3hv"
    t.integer "ccyviii3hv_datatype", :limit => 1
    t.integer "ccy1",                :limit => 1
    t.integer "ccy1_datatype",       :limit => 1
    t.integer "ccy2",                :limit => 1
    t.integer "ccy2_datatype",       :limit => 1
    t.string  "ccy2hv"
    t.integer "ccy2hv_datatype",     :limit => 1
    t.integer "ccy3",                :limit => 1
    t.integer "ccy3_datatype",       :limit => 1
    t.integer "ccy4",                :limit => 1
    t.integer "ccy4_datatype",       :limit => 1
    t.integer "ccy5",                :limit => 1
    t.integer "ccy5_datatype",       :limit => 1
    t.integer "ccy6",                :limit => 1
    t.integer "ccy6_datatype",       :limit => 1
    t.integer "ccy7",                :limit => 1
    t.integer "ccy7_datatype",       :limit => 1
    t.integer "ccy8",                :limit => 1
    t.integer "ccy8_datatype",       :limit => 1
    t.integer "ccy9",                :limit => 1
    t.integer "ccy9_datatype",       :limit => 1
    t.string  "ccy9hv"
    t.integer "ccy9hv_datatype",     :limit => 1
    t.integer "ccy10",               :limit => 1
    t.integer "ccy10_datatype",      :limit => 1
    t.integer "ccy11",               :limit => 1
    t.integer "ccy11_datatype",      :limit => 1
    t.integer "ccy12",               :limit => 1
    t.integer "ccy12_datatype",      :limit => 1
    t.integer "ccy13",               :limit => 1
    t.integer "ccy13_datatype",      :limit => 1
    t.integer "ccy14",               :limit => 1
    t.integer "ccy14_datatype",      :limit => 1
    t.integer "ccy15",               :limit => 1
    t.integer "ccy15_datatype",      :limit => 1
    t.integer "ccy16",               :limit => 1
    t.integer "ccy16_datatype",      :limit => 1
    t.integer "ccy17",               :limit => 1
    t.integer "ccy17_datatype",      :limit => 1
    t.integer "ccy18",               :limit => 1
    t.integer "ccy18_datatype",      :limit => 1
    t.integer "ccy19",               :limit => 1
    t.integer "ccy19_datatype",      :limit => 1
    t.integer "ccy20",               :limit => 1
    t.integer "ccy20_datatype",      :limit => 1
    t.integer "ccy21",               :limit => 1
    t.integer "ccy21_datatype",      :limit => 1
    t.integer "ccy22",               :limit => 1
    t.integer "ccy22_datatype",      :limit => 1
    t.integer "ccy23",               :limit => 1
    t.integer "ccy23_datatype",      :limit => 1
    t.integer "ccy24",               :limit => 1
    t.integer "ccy24_datatype",      :limit => 1
    t.integer "ccy25",               :limit => 1
    t.integer "ccy25_datatype",      :limit => 1
    t.integer "ccy26",               :limit => 1
    t.integer "ccy26_datatype",      :limit => 1
    t.integer "ccy27",               :limit => 1
    t.integer "ccy27_datatype",      :limit => 1
    t.integer "ccy28",               :limit => 1
    t.integer "ccy28_datatype",      :limit => 1
    t.integer "ccy29",               :limit => 1
    t.integer "ccy29_datatype",      :limit => 1
    t.string  "ccy29hv"
    t.integer "ccy29hv_datatype",    :limit => 1
    t.integer "ccy30",               :limit => 1
    t.integer "ccy30_datatype",      :limit => 1
    t.integer "ccy31",               :limit => 1
    t.integer "ccy31_datatype",      :limit => 1
    t.integer "ccy32",               :limit => 1
    t.integer "ccy32_datatype",      :limit => 1
    t.integer "ccy33",               :limit => 1
    t.integer "ccy33_datatype",      :limit => 1
    t.integer "ccy34",               :limit => 1
    t.integer "ccy34_datatype",      :limit => 1
    t.integer "ccy35",               :limit => 1
    t.integer "ccy35_datatype",      :limit => 1
    t.integer "ccy36",               :limit => 1
    t.integer "ccy36_datatype",      :limit => 1
    t.integer "ccy37",               :limit => 1
    t.integer "ccy37_datatype",      :limit => 1
    t.integer "ccy38",               :limit => 1
    t.integer "ccy38_datatype",      :limit => 1
    t.integer "ccy39",               :limit => 1
    t.integer "ccy39_datatype",      :limit => 1
    t.integer "ccy40",               :limit => 1
    t.integer "ccy40_datatype",      :limit => 1
    t.string  "ccy40hv"
    t.integer "ccy40hv_datatype",    :limit => 1
    t.integer "ccy41",               :limit => 1
    t.integer "ccy41_datatype",      :limit => 1
    t.integer "ccy42",               :limit => 1
    t.integer "ccy42_datatype",      :limit => 1
    t.integer "ccy43",               :limit => 1
    t.integer "ccy43_datatype",      :limit => 1
    t.integer "ccy44",               :limit => 1
    t.integer "ccy44_datatype",      :limit => 1
    t.integer "ccy45",               :limit => 1
    t.integer "ccy45_datatype",      :limit => 1
    t.integer "ccy46",               :limit => 1
    t.integer "ccy46_datatype",      :limit => 1
    t.string  "ccy46hv"
    t.integer "ccy46hv_datatype",    :limit => 1
    t.integer "ccy47",               :limit => 1
    t.integer "ccy47_datatype",      :limit => 1
    t.integer "ccy48",               :limit => 1
    t.integer "ccy48_datatype",      :limit => 1
    t.integer "ccy49",               :limit => 1
    t.integer "ccy49_datatype",      :limit => 1
    t.integer "ccy50",               :limit => 1
    t.integer "ccy50_datatype",      :limit => 1
    t.integer "ccy51",               :limit => 1
    t.integer "ccy51_datatype",      :limit => 1
    t.integer "ccy52",               :limit => 1
    t.integer "ccy52_datatype",      :limit => 1
    t.integer "ccy53",               :limit => 1
    t.integer "ccy53_datatype",      :limit => 1
    t.integer "ccy54",               :limit => 1
    t.integer "ccy54_datatype",      :limit => 1
    t.integer "ccy55",               :limit => 1
    t.integer "ccy55_datatype",      :limit => 1
    t.integer "ccy56a",              :limit => 1
    t.integer "ccy56a_datatype",     :limit => 1
    t.integer "ccy56b",              :limit => 1
    t.integer "ccy56b_datatype",     :limit => 1
    t.integer "ccy56c",              :limit => 1
    t.integer "ccy56c_datatype",     :limit => 1
    t.integer "ccy56d",              :limit => 1
    t.integer "ccy56d_datatype",     :limit => 1
    t.string  "ccy56dhv"
    t.integer "ccy56dhv_datatype",   :limit => 1
    t.integer "ccy56e",              :limit => 1
    t.integer "ccy56e_datatype",     :limit => 1
    t.integer "ccy56f",              :limit => 1
    t.integer "ccy56f_datatype",     :limit => 1
    t.integer "ccy56g",              :limit => 1
    t.integer "ccy56g_datatype",     :limit => 1
    t.integer "ccy56h",              :limit => 1
    t.integer "ccy56h_datatype",     :limit => 1
    t.string  "ccy56hhv"
    t.integer "ccy56hhv_datatype",   :limit => 1
    t.integer "ccy57",               :limit => 1
    t.integer "ccy57_datatype",      :limit => 1
    t.integer "ccy58",               :limit => 1
    t.integer "ccy58_datatype",      :limit => 1
    t.string  "ccy58hv"
    t.integer "ccy58hv_datatype",    :limit => 1
    t.integer "ccy59",               :limit => 1
    t.integer "ccy59_datatype",      :limit => 1
    t.integer "ccy60",               :limit => 1
    t.integer "ccy60_datatype",      :limit => 1
    t.integer "ccy61",               :limit => 1
    t.integer "ccy61_datatype",      :limit => 1
    t.integer "ccy62",               :limit => 1
    t.integer "ccy62_datatype",      :limit => 1
    t.integer "ccy63",               :limit => 1
    t.integer "ccy63_datatype",      :limit => 1
    t.integer "ccy64",               :limit => 1
    t.integer "ccy64_datatype",      :limit => 1
    t.integer "ccy65",               :limit => 1
    t.integer "ccy65_datatype",      :limit => 1
    t.integer "ccy66",               :limit => 1
    t.integer "ccy66_datatype",      :limit => 1
    t.string  "ccy66hv"
    t.integer "ccy66hv_datatype",    :limit => 1
    t.integer "ccy67",               :limit => 1
    t.integer "ccy67_datatype",      :limit => 1
    t.integer "ccy68",               :limit => 1
    t.integer "ccy68_datatype",      :limit => 1
    t.integer "ccy69",               :limit => 1
    t.integer "ccy69_datatype",      :limit => 1
    t.integer "ccy70",               :limit => 1
    t.integer "ccy70_datatype",      :limit => 1
    t.string  "ccy70hv"
    t.integer "ccy70hv_datatype",    :limit => 1
    t.integer "ccy71",               :limit => 1
    t.integer "ccy71_datatype",      :limit => 1
    t.integer "ccy72",               :limit => 1
    t.integer "ccy72_datatype",      :limit => 1
    t.integer "ccy73",               :limit => 1
    t.integer "ccy73_datatype",      :limit => 1
    t.string  "ccy73hv"
    t.integer "ccy73hv_datatype",    :limit => 1
    t.integer "ccy74",               :limit => 1
    t.integer "ccy74_datatype",      :limit => 1
    t.integer "ccy75",               :limit => 1
    t.integer "ccy75_datatype",      :limit => 1
    t.integer "ccy76",               :limit => 1
    t.integer "ccy76_datatype",      :limit => 1
    t.integer "ccy77",               :limit => 1
    t.integer "ccy77_datatype",      :limit => 1
    t.string  "ccy77hv"
    t.integer "ccy77hv_datatype",    :limit => 1
    t.integer "ccy78",               :limit => 1
    t.integer "ccy78_datatype",      :limit => 1
    t.integer "ccy79",               :limit => 1
    t.integer "ccy79_datatype",      :limit => 1
    t.string  "ccy79hv"
    t.integer "ccy79hv_datatype",    :limit => 1
    t.integer "ccy80",               :limit => 1
    t.integer "ccy80_datatype",      :limit => 1
    t.integer "ccy81",               :limit => 1
    t.integer "ccy81_datatype",      :limit => 1
    t.integer "ccy82",               :limit => 1
    t.integer "ccy82_datatype",      :limit => 1
    t.integer "ccy83",               :limit => 1
    t.integer "ccy83_datatype",      :limit => 1
    t.string  "ccy83hv"
    t.integer "ccy83hv_datatype",    :limit => 1
    t.integer "ccy84",               :limit => 1
    t.integer "ccy84_datatype",      :limit => 1
    t.string  "ccy84hv"
    t.integer "ccy84hv_datatype",    :limit => 1
    t.integer "ccy85",               :limit => 1
    t.integer "ccy85_datatype",      :limit => 1
    t.string  "ccy85hv"
    t.integer "ccy85hv_datatype",    :limit => 1
    t.integer "ccy86",               :limit => 1
    t.integer "ccy86_datatype",      :limit => 1
    t.integer "ccy87",               :limit => 1
    t.integer "ccy87_datatype",      :limit => 1
    t.integer "ccy88",               :limit => 1
    t.integer "ccy88_datatype",      :limit => 1
    t.integer "ccy89",               :limit => 1
    t.integer "ccy89_datatype",      :limit => 1
    t.integer "ccy90",               :limit => 1
    t.integer "ccy90_datatype",      :limit => 1
    t.integer "ccy91",               :limit => 1
    t.integer "ccy91_datatype",      :limit => 1
    t.integer "ccy92",               :limit => 1
    t.integer "ccy92_datatype",      :limit => 1
    t.string  "ccy92hv"
    t.integer "ccy92hv_datatype",    :limit => 1
    t.integer "ccy93",               :limit => 1
    t.integer "ccy93_datatype",      :limit => 1
    t.integer "ccy94",               :limit => 1
    t.integer "ccy94_datatype",      :limit => 1
    t.integer "ccy95",               :limit => 1
    t.integer "ccy95_datatype",      :limit => 1
    t.integer "ccy96",               :limit => 1
    t.integer "ccy96_datatype",      :limit => 1
    t.integer "ccy97",               :limit => 1
    t.integer "ccy97_datatype",      :limit => 1
    t.integer "ccy98",               :limit => 1
    t.integer "ccy98_datatype",      :limit => 1
    t.integer "ccy99",               :limit => 1
    t.integer "ccy99_datatype",      :limit => 1
    t.integer "ccy100",              :limit => 1
    t.integer "ccy100_datatype",     :limit => 1
    t.string  "ccy100hv"
    t.integer "ccy100hv_datatype",   :limit => 1
    t.integer "ccy101",              :limit => 1
    t.integer "ccy101_datatype",     :limit => 1
    t.integer "ccy102",              :limit => 1
    t.integer "ccy102_datatype",     :limit => 1
    t.integer "ccy103",              :limit => 1
    t.integer "ccy103_datatype",     :limit => 1
    t.integer "ccy104",              :limit => 1
    t.integer "ccy104_datatype",     :limit => 1
    t.integer "ccy105",              :limit => 1
    t.integer "ccy105_datatype",     :limit => 1
    t.string  "ccy105hv"
    t.integer "ccy105hv_datatype",   :limit => 1
    t.integer "ccy106",              :limit => 1
    t.integer "ccy106_datatype",     :limit => 1
    t.integer "ccy107",              :limit => 1
    t.integer "ccy107_datatype",     :limit => 1
    t.integer "ccy108",              :limit => 1
    t.integer "ccy108_datatype",     :limit => 1
    t.integer "ccy109",              :limit => 1
    t.integer "ccy109_datatype",     :limit => 1
    t.integer "ccy110",              :limit => 1
    t.integer "ccy110_datatype",     :limit => 1
    t.integer "ccy111",              :limit => 1
    t.integer "ccy111_datatype",     :limit => 1
    t.integer "ccy112",              :limit => 1
    t.integer "ccy112_datatype",     :limit => 1
    t.string  "ccy113hv"
    t.integer "ccy113hv_datatype",   :limit => 1
    t.integer "ccyiaspt",            :limit => 1
    t.integer "ccyiaspt_datatype",   :limit => 1
    t.integer "ccyibspt",            :limit => 1
    t.integer "ccyibspt_datatype",   :limit => 1
    t.integer "ccyicspt",            :limit => 1
    t.integer "ccyicspt_datatype",   :limit => 1
    t.integer "ccyiasp",             :limit => 1
    t.integer "ccyiasp_datatype",    :limit => 1
    t.integer "ccyibsp",             :limit => 1
    t.integer "ccyibsp_datatype",    :limit => 1
    t.integer "ccyicsp",             :limit => 1
    t.integer "ccyicsp_datatype",    :limit => 1
    t.integer "ccyiiah",             :limit => 1
    t.integer "ccyiiah_datatype",    :limit => 1
    t.integer "ccyiiaht",            :limit => 1
    t.integer "ccyiiaht_datatype",   :limit => 1
    t.integer "ccyiibh",             :limit => 1
    t.integer "ccyiibh_datatype",    :limit => 1
    t.integer "ccyiich",             :limit => 1
    t.integer "ccyiich_datatype",    :limit => 1
    t.integer "ccyiibht",            :limit => 1
    t.integer "ccyiibht_datatype",   :limit => 1
    t.integer "ccyiicht",            :limit => 1
    t.integer "ccyiicht_datatype",   :limit => 1
    t.integer "ccyiiiaa",            :limit => 1
    t.integer "ccyiiiaa_datatype",   :limit => 1
    t.integer "ccyiiiba",            :limit => 1
    t.integer "ccyiiiba_datatype",   :limit => 1
    t.integer "ccyiiica",            :limit => 1
    t.integer "ccyiiica_datatype",   :limit => 1
    t.integer "ccyivja",             :limit => 1
    t.integer "ccyivja_datatype",    :limit => 1
    t.integer "ccyivjb",             :limit => 1
    t.integer "ccyivjb_datatype",    :limit => 1
    t.integer "ccyivjc",             :limit => 1
    t.integer "ccyivjc_datatype",    :limit => 1
    t.integer "caviian1",            :limit => 1
    t.integer "caviian1_datatype",   :limit => 1
    t.integer "caviian2",            :limit => 1
    t.integer "caviian2_datatype",   :limit => 1
    t.integer "ctcunder",            :limit => 1
    t.integer "ctcunder_datatype",   :limit => 1
    t.integer "ctcgaaom",            :limit => 1
    t.integer "ctcgaaom_datatype",   :limit => 1
  end

  add_index "export_variables_survey_ccy", ["journal_id"], :name => "index_export_variables_survey_ccy_on_journal_id"

  create_table "export_variables_survey_ct", :force => true do |t|
    t.integer "journal_id",        :limit => 3
    t.string  "ctinst"
    t.integer "ctinst_datatype",   :limit => 1
    t.integer "ctpasty",           :limit => 1
    t.integer "ctpasty_datatype",  :limit => 1
    t.integer "ctpashv",           :limit => 1
    t.integer "ctpashv_datatype",  :limit => 1
    t.integer "ctborn",            :limit => 1
    t.integer "ctborn_datatype",   :limit => 1
    t.integer "cttimer",           :limit => 1
    t.integer "cttimer_datatype",  :limit => 1
    t.integer "ctkentid",          :limit => 1
    t.integer "ctkentid_datatype", :limit => 1
    t.integer "cttraen",           :limit => 1
    t.integer "cttraen_datatype",  :limit => 1
    t.integer "cttraehv",          :limit => 1
    t.integer "cttraehv_datatype", :limit => 1
    t.integer "ct1",               :limit => 1
    t.integer "ct1_datatype",      :limit => 1
    t.integer "ct2",               :limit => 1
    t.integer "ct2_datatype",      :limit => 1
    t.integer "ct3",               :limit => 1
    t.integer "ct3_datatype",      :limit => 1
    t.integer "ct4",               :limit => 1
    t.integer "ct4_datatype",      :limit => 1
    t.integer "ct5",               :limit => 1
    t.integer "ct5_datatype",      :limit => 1
    t.integer "ct6",               :limit => 1
    t.integer "ct6_datatype",      :limit => 1
    t.integer "ct7",               :limit => 1
    t.integer "ct7_datatype",      :limit => 1
    t.integer "ct8",               :limit => 1
    t.integer "ct8_datatype",      :limit => 1
    t.integer "ct9",               :limit => 1
    t.integer "ct9_datatype",      :limit => 1
    t.integer "ct10",              :limit => 1
    t.integer "ct10_datatype",     :limit => 1
    t.integer "ct11",              :limit => 1
    t.integer "ct11_datatype",     :limit => 1
    t.integer "ct12",              :limit => 1
    t.integer "ct12_datatype",     :limit => 1
    t.integer "ct13",              :limit => 1
    t.integer "ct13_datatype",     :limit => 1
    t.integer "ct14",              :limit => 1
    t.integer "ct14_datatype",     :limit => 1
    t.integer "ct15",              :limit => 1
    t.integer "ct15_datatype",     :limit => 1
    t.integer "ct16",              :limit => 1
    t.integer "ct16_datatype",     :limit => 1
    t.integer "ct17",              :limit => 1
    t.integer "ct17_datatype",     :limit => 1
    t.integer "ct18",              :limit => 1
    t.integer "ct18_datatype",     :limit => 1
    t.integer "ct19",              :limit => 1
    t.integer "ct19_datatype",     :limit => 1
    t.integer "ct20",              :limit => 1
    t.integer "ct20_datatype",     :limit => 1
    t.integer "ct21",              :limit => 1
    t.integer "ct21_datatype",     :limit => 1
    t.integer "ct22",              :limit => 1
    t.integer "ct22_datatype",     :limit => 1
    t.integer "ct23",              :limit => 1
    t.integer "ct23_datatype",     :limit => 1
    t.integer "ct24",              :limit => 1
    t.integer "ct24_datatype",     :limit => 1
    t.integer "ct25",              :limit => 1
    t.integer "ct25_datatype",     :limit => 1
    t.integer "ct26",              :limit => 1
    t.integer "ct26_datatype",     :limit => 1
    t.integer "ct27",              :limit => 1
    t.integer "ct27_datatype",     :limit => 1
    t.integer "ct28",              :limit => 1
    t.integer "ct28_datatype",     :limit => 1
    t.integer "ct29",              :limit => 1
    t.integer "ct29_datatype",     :limit => 1
    t.integer "ct30",              :limit => 1
    t.integer "ct30_datatype",     :limit => 1
    t.integer "ct31",              :limit => 1
    t.integer "ct31_datatype",     :limit => 1
    t.string  "ct31hv"
    t.integer "ct31hv_datatype",   :limit => 1
    t.integer "ct32",              :limit => 1
    t.integer "ct32_datatype",     :limit => 1
    t.string  "ct32hv"
    t.integer "ct32hv_datatype",   :limit => 1
    t.integer "ct33",              :limit => 1
    t.integer "ct33_datatype",     :limit => 1
    t.integer "ct34",              :limit => 1
    t.integer "ct34_datatype",     :limit => 1
    t.integer "ct35",              :limit => 1
    t.integer "ct35_datatype",     :limit => 1
    t.integer "ct36",              :limit => 1
    t.integer "ct36_datatype",     :limit => 1
    t.integer "ct37",              :limit => 1
    t.integer "ct37_datatype",     :limit => 1
    t.integer "ct38",              :limit => 1
    t.integer "ct38_datatype",     :limit => 1
    t.integer "ct39",              :limit => 1
    t.integer "ct39_datatype",     :limit => 1
    t.integer "ct40",              :limit => 1
    t.integer "ct40_datatype",     :limit => 1
    t.integer "ct41",              :limit => 1
    t.integer "ct41_datatype",     :limit => 1
    t.integer "ct42",              :limit => 1
    t.integer "ct42_datatype",     :limit => 1
    t.integer "ct43",              :limit => 1
    t.integer "ct43_datatype",     :limit => 1
    t.integer "ct44",              :limit => 1
    t.integer "ct44_datatype",     :limit => 1
    t.integer "ct45",              :limit => 1
    t.integer "ct45_datatype",     :limit => 1
    t.integer "ct46",              :limit => 1
    t.integer "ct46_datatype",     :limit => 1
    t.string  "ct46hv"
    t.integer "ct46hv_datatype",   :limit => 1
    t.integer "ct47",              :limit => 1
    t.integer "ct47_datatype",     :limit => 1
    t.integer "ct48",              :limit => 1
    t.integer "ct48_datatype",     :limit => 1
    t.integer "ct49",              :limit => 1
    t.integer "ct49_datatype",     :limit => 1
    t.integer "ct50",              :limit => 1
    t.integer "ct50_datatype",     :limit => 1
    t.integer "ct51",              :limit => 1
    t.integer "ct51_datatype",     :limit => 1
    t.integer "ct52",              :limit => 1
    t.integer "ct52_datatype",     :limit => 1
    t.integer "ct53",              :limit => 1
    t.integer "ct53_datatype",     :limit => 1
    t.integer "ct54",              :limit => 1
    t.integer "ct54_datatype",     :limit => 1
    t.string  "ct54hv"
    t.integer "ct54hv_datatype",   :limit => 1
    t.integer "ct55",              :limit => 1
    t.integer "ct55_datatype",     :limit => 1
    t.integer "ct56",              :limit => 1
    t.integer "ct56_datatype",     :limit => 1
    t.integer "ct57",              :limit => 1
    t.integer "ct57_datatype",     :limit => 1
    t.integer "ct58",              :limit => 1
    t.integer "ct58_datatype",     :limit => 1
    t.integer "ct59",              :limit => 1
    t.integer "ct59_datatype",     :limit => 1
    t.integer "ct60",              :limit => 1
    t.integer "ct60_datatype",     :limit => 1
    t.integer "ct61",              :limit => 1
    t.integer "ct61_datatype",     :limit => 1
    t.integer "ct62",              :limit => 1
    t.integer "ct62_datatype",     :limit => 1
    t.integer "ct63",              :limit => 1
    t.integer "ct63_datatype",     :limit => 1
    t.integer "ct64",              :limit => 1
    t.integer "ct64_datatype",     :limit => 1
    t.integer "ct65",              :limit => 1
    t.integer "ct65_datatype",     :limit => 1
    t.integer "ct66",              :limit => 1
    t.integer "ct66_datatype",     :limit => 1
    t.integer "ct67",              :limit => 1
    t.integer "ct67_datatype",     :limit => 1
    t.integer "ct68",              :limit => 1
    t.integer "ct68_datatype",     :limit => 1
    t.integer "ct69",              :limit => 1
    t.integer "ct69_datatype",     :limit => 1
    t.integer "ct70",              :limit => 1
    t.integer "ct70_datatype",     :limit => 1
    t.integer "ct71",              :limit => 1
    t.integer "ct71_datatype",     :limit => 1
    t.integer "ct72",              :limit => 1
    t.integer "ct72_datatype",     :limit => 1
    t.integer "ct73",              :limit => 1
    t.integer "ct73_datatype",     :limit => 1
    t.integer "ct74",              :limit => 1
    t.integer "ct74_datatype",     :limit => 1
    t.integer "ct75",              :limit => 1
    t.integer "ct75_datatype",     :limit => 1
    t.integer "ct76",              :limit => 1
    t.integer "ct76_datatype",     :limit => 1
    t.string  "ct76hv"
    t.integer "ct76hv_datatype",   :limit => 1
    t.integer "ct77",              :limit => 1
    t.integer "ct77_datatype",     :limit => 1
    t.integer "ct78",              :limit => 1
    t.integer "ct78_datatype",     :limit => 1
    t.integer "ct79",              :limit => 1
    t.integer "ct79_datatype",     :limit => 1
    t.integer "ct80",              :limit => 1
    t.integer "ct80_datatype",     :limit => 1
    t.string  "ct80hv"
    t.integer "ct80hv_datatype",   :limit => 1
    t.integer "ct81",              :limit => 1
    t.integer "ct81_datatype",     :limit => 1
    t.integer "ct82",              :limit => 1
    t.integer "ct82_datatype",     :limit => 1
    t.integer "ct83",              :limit => 1
    t.integer "ct83_datatype",     :limit => 1
    t.integer "ct84",              :limit => 1
    t.integer "ct84_datatype",     :limit => 1
    t.integer "ct85",              :limit => 1
    t.integer "ct85_datatype",     :limit => 1
    t.integer "ct86",              :limit => 1
    t.integer "ct86_datatype",     :limit => 1
    t.integer "ct87",              :limit => 1
    t.integer "ct87_datatype",     :limit => 1
    t.integer "ct88",              :limit => 1
    t.integer "ct88_datatype",     :limit => 1
    t.integer "ct89",              :limit => 1
    t.integer "ct89_datatype",     :limit => 1
    t.integer "ct90",              :limit => 1
    t.integer "ct90_datatype",     :limit => 1
    t.integer "ct91",              :limit => 1
    t.integer "ct91_datatype",     :limit => 1
    t.integer "ct92",              :limit => 1
    t.integer "ct92_datatype",     :limit => 1
    t.string  "ct92hv"
    t.integer "ct92hv_datatype",   :limit => 1
    t.integer "ct93",              :limit => 1
    t.integer "ct93_datatype",     :limit => 1
    t.integer "ct94",              :limit => 1
    t.integer "ct94_datatype",     :limit => 1
    t.integer "ct95",              :limit => 1
    t.integer "ct95_datatype",     :limit => 1
    t.integer "ct96",              :limit => 1
    t.integer "ct96_datatype",     :limit => 1
    t.integer "ct97",              :limit => 1
    t.integer "ct97_datatype",     :limit => 1
    t.integer "ct98",              :limit => 1
    t.integer "ct98_datatype",     :limit => 1
    t.integer "ct99",              :limit => 1
    t.integer "ct99_datatype",     :limit => 1
    t.integer "ct100",             :limit => 1
    t.integer "ct100_datatype",    :limit => 1
    t.string  "ct100hv"
    t.integer "ct100hv_datatype",  :limit => 1
    t.integer "cthandic",          :limit => 1
    t.integer "cthandic_datatype", :limit => 1
    t.string  "cthandhv"
    t.integer "cthandhv_datatype", :limit => 1
    t.string  "ctbekyhv"
    t.integer "ctbekyhv_datatype", :limit => 1
    t.string  "ctbedshv"
    t.integer "ctbedshv_datatype", :limit => 1
  end

  add_index "export_variables_survey_ct", ["journal_id"], :name => "index_export_variables_survey_ct_on_journal_id"

  create_table "export_variables_survey_tt", :force => true do |t|
    t.integer "journal_id",           :limit => 3
    t.integer "ttkltrin",             :limit => 1
    t.integer "ttkltrin_datatype",    :limit => 1
    t.string  "ttskolen"
    t.integer "ttskolen_datatype",    :limit => 1
    t.integer "ttiikend",             :limit => 1
    t.integer "ttiikend_datatype",    :limit => 1
    t.integer "ttlekt",               :limit => 1
    t.integer "ttlekt_datatype",      :limit => 1
    t.string  "ttv"
    t.integer "ttv_datatype",         :limit => 1
    t.integer "ttcgomkl",             :limit => 1
    t.integer "ttcgomkl_datatype",    :limit => 1
    t.integer "ttcgomhv",             :limit => 1
    t.integer "ttcgomhv_datatype",    :limit => 1
    t.integer "taviivu2",             :limit => 1
    t.integer "taviivu2_datatype",    :limit => 1
    t.integer "taviian1",             :limit => 1
    t.integer "taviian1_datatype",    :limit => 1
    t.integer "taviian2",             :limit => 1
    t.integer "taviian2_datatype",    :limit => 1
    t.integer "ttviiihu",             :limit => 1
    t.integer "ttviiihu_datatype",    :limit => 1
    t.string  "ttixhandhv"
    t.integer "ttixhandhv_datatype",  :limit => 1
    t.integer "ttxbekym",             :limit => 1
    t.integer "ttxbekym_datatype",    :limit => 1
    t.integer "ttxibedsthv",          :limit => 1
    t.integer "ttxibedsthv_datatype", :limit => 1
    t.integer "tt1",                  :limit => 1
    t.integer "tt1_datatype",         :limit => 1
    t.integer "tt2",                  :limit => 1
    t.integer "tt2_datatype",         :limit => 1
    t.integer "tt3",                  :limit => 1
    t.integer "tt3_datatype",         :limit => 1
    t.integer "tt4",                  :limit => 1
    t.integer "tt4_datatype",         :limit => 1
    t.integer "tt5",                  :limit => 1
    t.integer "tt5_datatype",         :limit => 1
    t.integer "tt6",                  :limit => 1
    t.integer "tt6_datatype",         :limit => 1
    t.integer "tt7",                  :limit => 1
    t.integer "tt7_datatype",         :limit => 1
    t.integer "tt8",                  :limit => 1
    t.integer "tt8_datatype",         :limit => 1
    t.integer "tt9",                  :limit => 1
    t.integer "tt9_datatype",         :limit => 1
    t.string  "tt9hv"
    t.integer "tt9hv_datatype",       :limit => 1
    t.integer "tt10",                 :limit => 1
    t.integer "tt10_datatype",        :limit => 1
    t.integer "tt11",                 :limit => 1
    t.integer "tt11_datatype",        :limit => 1
    t.integer "tt12",                 :limit => 1
    t.integer "tt12_datatype",        :limit => 1
    t.integer "tt13",                 :limit => 1
    t.integer "tt13_datatype",        :limit => 1
    t.integer "tt14",                 :limit => 1
    t.integer "tt14_datatype",        :limit => 1
    t.integer "tt15",                 :limit => 1
    t.integer "tt15_datatype",        :limit => 1
    t.integer "tt16",                 :limit => 1
    t.integer "tt16_datatype",        :limit => 1
    t.integer "tt17",                 :limit => 1
    t.integer "tt17_datatype",        :limit => 1
    t.integer "tt18",                 :limit => 1
    t.integer "tt18_datatype",        :limit => 1
    t.integer "tt19",                 :limit => 1
    t.integer "tt19_datatype",        :limit => 1
    t.integer "tt20",                 :limit => 1
    t.integer "tt20_datatype",        :limit => 1
    t.integer "tt21",                 :limit => 1
    t.integer "tt21_datatype",        :limit => 1
    t.integer "tt22",                 :limit => 1
    t.integer "tt22_datatype",        :limit => 1
    t.integer "tt23",                 :limit => 1
    t.integer "tt23_datatype",        :limit => 1
    t.integer "tt24",                 :limit => 1
    t.integer "tt24_datatype",        :limit => 1
    t.integer "tt25",                 :limit => 1
    t.integer "tt25_datatype",        :limit => 1
    t.integer "tt26",                 :limit => 1
    t.integer "tt26_datatype",        :limit => 1
    t.integer "tt27",                 :limit => 1
    t.integer "tt27_datatype",        :limit => 1
    t.integer "tt28",                 :limit => 1
    t.integer "tt28_datatype",        :limit => 1
    t.integer "tt29",                 :limit => 1
    t.integer "tt29_datatype",        :limit => 1
    t.string  "tt29hv"
    t.integer "tt29hv_datatype",      :limit => 1
    t.integer "tt30",                 :limit => 1
    t.integer "tt30_datatype",        :limit => 1
    t.integer "tt31",                 :limit => 1
    t.integer "tt31_datatype",        :limit => 1
    t.integer "tt32",                 :limit => 1
    t.integer "tt32_datatype",        :limit => 1
    t.integer "tt33",                 :limit => 1
    t.integer "tt33_datatype",        :limit => 1
    t.integer "tt34",                 :limit => 1
    t.integer "tt34_datatype",        :limit => 1
    t.integer "tt35",                 :limit => 1
    t.integer "tt35_datatype",        :limit => 1
    t.integer "tt36",                 :limit => 1
    t.integer "tt36_datatype",        :limit => 1
    t.integer "tt37",                 :limit => 1
    t.integer "tt37_datatype",        :limit => 1
    t.integer "tt38",                 :limit => 1
    t.integer "tt38_datatype",        :limit => 1
    t.integer "tt39",                 :limit => 1
    t.integer "tt39_datatype",        :limit => 1
    t.integer "tt40",                 :limit => 1
    t.integer "tt40_datatype",        :limit => 1
    t.string  "tt40hv"
    t.integer "tt40hv_datatype",      :limit => 1
    t.integer "tt41",                 :limit => 1
    t.integer "tt41_datatype",        :limit => 1
    t.integer "tt42",                 :limit => 1
    t.integer "tt42_datatype",        :limit => 1
    t.integer "tt43",                 :limit => 1
    t.integer "tt43_datatype",        :limit => 1
    t.integer "tt44",                 :limit => 1
    t.integer "tt44_datatype",        :limit => 1
    t.integer "tt45",                 :limit => 1
    t.integer "tt45_datatype",        :limit => 1
    t.integer "tt46",                 :limit => 1
    t.integer "tt46_datatype",        :limit => 1
    t.string  "tt46hv"
    t.integer "tt46hv_datatype",      :limit => 1
    t.integer "tt47",                 :limit => 1
    t.integer "tt47_datatype",        :limit => 1
    t.integer "tt48",                 :limit => 1
    t.integer "tt48_datatype",        :limit => 1
    t.integer "tt49",                 :limit => 1
    t.integer "tt49_datatype",        :limit => 1
    t.integer "tt50",                 :limit => 1
    t.integer "tt50_datatype",        :limit => 1
    t.integer "tt51",                 :limit => 1
    t.integer "tt51_datatype",        :limit => 1
    t.integer "tt52",                 :limit => 1
    t.integer "tt52_datatype",        :limit => 1
    t.integer "tt53",                 :limit => 1
    t.integer "tt53_datatype",        :limit => 1
    t.integer "tt54",                 :limit => 1
    t.integer "tt54_datatype",        :limit => 1
    t.integer "tt55",                 :limit => 1
    t.integer "tt55_datatype",        :limit => 1
    t.integer "tt56a",                :limit => 1
    t.integer "tt56a_datatype",       :limit => 1
    t.integer "tt56b",                :limit => 1
    t.integer "tt56b_datatype",       :limit => 1
    t.integer "tt56c",                :limit => 1
    t.integer "tt56c_datatype",       :limit => 1
    t.integer "tt56d",                :limit => 1
    t.integer "tt56d_datatype",       :limit => 1
    t.string  "tt56dhv"
    t.integer "tt56dhv_datatype",     :limit => 1
    t.integer "tt56e",                :limit => 1
    t.integer "tt56e_datatype",       :limit => 1
    t.integer "tt56f",                :limit => 1
    t.integer "tt56f_datatype",       :limit => 1
    t.integer "tt56g",                :limit => 1
    t.integer "tt56g_datatype",       :limit => 1
    t.integer "tt56h",                :limit => 1
    t.integer "tt56h_datatype",       :limit => 1
    t.string  "tt56hhv"
    t.integer "tt56hhv_datatype",     :limit => 1
    t.integer "tt57",                 :limit => 1
    t.integer "tt57_datatype",        :limit => 1
    t.integer "tt58",                 :limit => 1
    t.integer "tt58_datatype",        :limit => 1
    t.string  "tt58hv"
    t.integer "tt58hv_datatype",      :limit => 1
    t.integer "tt59",                 :limit => 1
    t.integer "tt59_datatype",        :limit => 1
    t.integer "tt60",                 :limit => 1
    t.integer "tt60_datatype",        :limit => 1
    t.integer "tt61",                 :limit => 1
    t.integer "tt61_datatype",        :limit => 1
    t.integer "tt62",                 :limit => 1
    t.integer "tt62_datatype",        :limit => 1
    t.integer "tt63",                 :limit => 1
    t.integer "tt63_datatype",        :limit => 1
    t.integer "tt64",                 :limit => 1
    t.integer "tt64_datatype",        :limit => 1
    t.integer "tt65",                 :limit => 1
    t.integer "tt65_datatype",        :limit => 1
    t.integer "tt66",                 :limit => 1
    t.integer "tt66_datatype",        :limit => 1
    t.string  "tt66hv"
    t.integer "tt66hv_datatype",      :limit => 1
    t.integer "tt67",                 :limit => 1
    t.integer "tt67_datatype",        :limit => 1
    t.integer "tt68",                 :limit => 1
    t.integer "tt68_datatype",        :limit => 1
    t.integer "tt69",                 :limit => 1
    t.integer "tt69_datatype",        :limit => 1
    t.integer "tt70",                 :limit => 1
    t.integer "tt70_datatype",        :limit => 1
    t.string  "tt70hv"
    t.integer "tt70hv_datatype",      :limit => 1
    t.integer "tt71",                 :limit => 1
    t.integer "tt71_datatype",        :limit => 1
    t.integer "tt72",                 :limit => 1
    t.integer "tt72_datatype",        :limit => 1
    t.integer "tt73",                 :limit => 1
    t.integer "tt73_datatype",        :limit => 1
    t.string  "tt73hv"
    t.integer "tt73hv_datatype",      :limit => 1
    t.integer "tt74",                 :limit => 1
    t.integer "tt74_datatype",        :limit => 1
    t.integer "tt75",                 :limit => 1
    t.integer "tt75_datatype",        :limit => 1
    t.integer "tt76",                 :limit => 1
    t.integer "tt76_datatype",        :limit => 1
    t.integer "tt77",                 :limit => 1
    t.integer "tt77_datatype",        :limit => 1
    t.integer "tt78",                 :limit => 1
    t.integer "tt78_datatype",        :limit => 1
    t.integer "tt79",                 :limit => 1
    t.integer "tt79_datatype",        :limit => 1
    t.string  "tt79hv"
    t.integer "tt79hv_datatype",      :limit => 1
    t.integer "tt80",                 :limit => 1
    t.integer "tt80_datatype",        :limit => 1
    t.integer "tt81",                 :limit => 1
    t.integer "tt81_datatype",        :limit => 1
    t.integer "tt82",                 :limit => 1
    t.integer "tt82_datatype",        :limit => 1
    t.integer "tt83",                 :limit => 1
    t.integer "tt83_datatype",        :limit => 1
    t.string  "tt83hv"
    t.integer "tt83hv_datatype",      :limit => 1
    t.integer "tt84",                 :limit => 1
    t.integer "tt84_datatype",        :limit => 1
    t.string  "tt84hv"
    t.integer "tt84hv_datatype",      :limit => 1
    t.integer "tt85",                 :limit => 1
    t.integer "tt85_datatype",        :limit => 1
    t.string  "tt85hv"
    t.integer "tt85hv_datatype",      :limit => 1
    t.integer "tt86",                 :limit => 1
    t.integer "tt86_datatype",        :limit => 1
    t.integer "tt87",                 :limit => 1
    t.integer "tt87_datatype",        :limit => 1
    t.integer "tt88",                 :limit => 1
    t.integer "tt88_datatype",        :limit => 1
    t.integer "tt89",                 :limit => 1
    t.integer "tt89_datatype",        :limit => 1
    t.integer "tt90",                 :limit => 1
    t.integer "tt90_datatype",        :limit => 1
    t.integer "tt91",                 :limit => 1
    t.integer "tt91_datatype",        :limit => 1
    t.integer "tt92",                 :limit => 1
    t.integer "tt92_datatype",        :limit => 1
    t.integer "tt93",                 :limit => 1
    t.integer "tt93_datatype",        :limit => 1
    t.integer "tt94",                 :limit => 1
    t.integer "tt94_datatype",        :limit => 1
    t.integer "tt95",                 :limit => 1
    t.integer "tt95_datatype",        :limit => 1
    t.integer "tt96",                 :limit => 1
    t.integer "tt96_datatype",        :limit => 1
    t.integer "tt97",                 :limit => 1
    t.integer "tt97_datatype",        :limit => 1
    t.integer "tt98",                 :limit => 1
    t.integer "tt98_datatype",        :limit => 1
    t.integer "tt99",                 :limit => 1
    t.integer "tt99_datatype",        :limit => 1
    t.integer "tt100",                :limit => 1
    t.integer "tt100_datatype",       :limit => 1
    t.integer "tt101",                :limit => 1
    t.integer "tt101_datatype",       :limit => 1
    t.integer "tt102",                :limit => 1
    t.integer "tt102_datatype",       :limit => 1
    t.integer "tt103",                :limit => 1
    t.integer "tt103_datatype",       :limit => 1
    t.integer "tt104",                :limit => 1
    t.integer "tt104_datatype",       :limit => 1
    t.integer "tt105",                :limit => 1
    t.integer "tt105_datatype",       :limit => 1
    t.string  "tt105hv"
    t.integer "tt105hv_datatype",     :limit => 1
    t.integer "tt106",                :limit => 1
    t.integer "tt106_datatype",       :limit => 1
    t.integer "tt107",                :limit => 1
    t.integer "tt107_datatype",       :limit => 1
    t.integer "tt108",                :limit => 1
    t.integer "tt108_datatype",       :limit => 1
    t.integer "tt109",                :limit => 1
    t.integer "tt109_datatype",       :limit => 1
    t.integer "tt110",                :limit => 1
    t.integer "tt110_datatype",       :limit => 1
    t.integer "tt111",                :limit => 1
    t.integer "tt111_datatype",       :limit => 1
    t.integer "tt112",                :limit => 1
    t.integer "tt112_datatype",       :limit => 1
    t.string  "tt113hv"
    t.integer "tt113hv_datatype",     :limit => 1
    t.integer "ttkent",               :limit => 1
    t.integer "ttkent_datatype",      :limit => 1
    t.string  "ttfag"
    t.integer "ttfag_datatype",       :limit => 1
    t.integer "ttcunder",             :limit => 1
    t.integer "ttcunder_datatype",    :limit => 1
    t.integer "ttcundty",             :limit => 1
    t.integer "ttcundty_datatype",    :limit => 1
    t.integer "ttcgaaom",             :limit => 1
    t.integer "ttcgaaom_datatype",    :limit => 1
    t.integer "taviivu1",             :limit => 1
    t.integer "taviivu1_datatype",    :limit => 1
    t.integer "taviilae",             :limit => 1
    t.integer "taviilae_datatype",    :limit => 1
    t.integer "taviista",             :limit => 1
    t.integer "taviista_datatype",    :limit => 1
    t.integer "taviimat",             :limit => 1
    t.integer "taviimat_datatype",    :limit => 1
    t.integer "taviinat",             :limit => 1
    t.integer "taviinat_datatype",    :limit => 1
    t.integer "taviieng",             :limit => 1
    t.integer "taviieng_datatype",    :limit => 1
    t.integer "ttviiiar",             :limit => 1
    t.integer "ttviiiar_datatype",    :limit => 1
    t.integer "ttviiiop",             :limit => 1
    t.integer "ttviiiop_datatype",    :limit => 1
    t.integer "ttviiila",             :limit => 1
    t.integer "ttviiila_datatype",    :limit => 1
  end

  add_index "export_variables_survey_tt", ["journal_id"], :name => "index_export_variables_survey_tt_on_journal_id"

  create_table "export_variables_survey_ycy", :force => true do |t|
    t.integer "journal_id",        :limit => 3
    t.integer "ycyiaspg",          :limit => 1
    t.integer "ycyiaspg_datatype", :limit => 1
    t.integer "ycyibspg",          :limit => 1
    t.integer "ycyibspg_datatype", :limit => 1
    t.integer "ycyicspg",          :limit => 1
    t.integer "ycyicspg_datatype", :limit => 1
    t.integer "ycyiihob",          :limit => 1
    t.integer "ycyiihob_datatype", :limit => 1
    t.integer "ycyiiahg",          :limit => 1
    t.integer "ycyiiahg_datatype", :limit => 1
    t.integer "ycyiibhg",          :limit => 1
    t.integer "ycyiibhg_datatype", :limit => 1
    t.integer "ycyiichg",          :limit => 1
    t.integer "ycyiichg_datatype", :limit => 1
    t.integer "ycyiiifo",          :limit => 1
    t.integer "ycyiiifo_datatype", :limit => 1
    t.integer "ycyiiiaa",          :limit => 1
    t.integer "ycyiiiaa_datatype", :limit => 1
    t.integer "ycyiiiba",          :limit => 1
    t.integer "ycyiiiba_datatype", :limit => 1
    t.integer "ycyiiica",          :limit => 1
    t.integer "ycyiiica_datatype", :limit => 1
    t.integer "ycyivjob",          :limit => 1
    t.integer "ycyivjob_datatype", :limit => 1
    t.integer "ycyivjag",          :limit => 1
    t.integer "ycyivjag_datatype", :limit => 1
    t.integer "ycyivjbg",          :limit => 1
    t.integer "ycyivjbg_datatype", :limit => 1
    t.integer "ycyivjcg",          :limit => 1
    t.integer "ycyivjcg_datatype", :limit => 1
    t.integer "ycyv1ven",          :limit => 1
    t.integer "ycyv1ven_datatype", :limit => 1
    t.integer "ycyv2vea",          :limit => 1
    t.integer "ycyv2vea_datatype", :limit => 1
    t.integer "ycyvisos",          :limit => 1
    t.integer "ycyvisos_datatype", :limit => 1
    t.integer "ycyvibor",          :limit => 1
    t.integer "ycyvibor_datatype", :limit => 1
    t.integer "ycyvifor",          :limit => 1
    t.integer "ycyvifor_datatype", :limit => 1
    t.integer "ycyviale",          :limit => 1
    t.integer "ycyviale_datatype", :limit => 1
    t.integer "yaviilae",          :limit => 1
    t.integer "yaviilae_datatype", :limit => 1
    t.integer "yaviista",          :limit => 1
    t.integer "yaviista_datatype", :limit => 1
    t.integer "yaviimat",          :limit => 1
    t.integer "yaviimat_datatype", :limit => 1
    t.integer "yaviinat",          :limit => 1
    t.integer "yaviinat_datatype", :limit => 1
    t.integer "yaviieng",          :limit => 1
    t.integer "yaviieng_datatype", :limit => 1
    t.integer "yaviivu1",          :limit => 1
    t.integer "yaviivu1_datatype", :limit => 1
    t.integer "yaviivu2",          :limit => 1
    t.integer "yaviivu2_datatype", :limit => 1
    t.integer "ycy1",              :limit => 1
    t.integer "ycy1_datatype",     :limit => 1
    t.integer "ycy2",              :limit => 1
    t.integer "ycy2_datatype",     :limit => 1
    t.string  "ycy2hv"
    t.integer "ycy2hv_datatype",   :limit => 1
    t.integer "ycy3",              :limit => 1
    t.integer "ycy3_datatype",     :limit => 1
    t.integer "ycy4",              :limit => 1
    t.integer "ycy4_datatype",     :limit => 1
    t.integer "ycy5",              :limit => 1
    t.integer "ycy5_datatype",     :limit => 1
    t.integer "ycy6",              :limit => 1
    t.integer "ycy6_datatype",     :limit => 1
    t.integer "ycy7",              :limit => 1
    t.integer "ycy7_datatype",     :limit => 1
    t.integer "ycy8",              :limit => 1
    t.integer "ycy8_datatype",     :limit => 1
    t.integer "ycy9",              :limit => 1
    t.integer "ycy9_datatype",     :limit => 1
    t.string  "ycy9hv"
    t.integer "ycy9hv_datatype",   :limit => 1
    t.integer "ycy10",             :limit => 1
    t.integer "ycy10_datatype",    :limit => 1
    t.integer "ycy11",             :limit => 1
    t.integer "ycy11_datatype",    :limit => 1
    t.integer "ycy12",             :limit => 1
    t.integer "ycy12_datatype",    :limit => 1
    t.integer "ycy13",             :limit => 1
    t.integer "ycy13_datatype",    :limit => 1
    t.integer "ycy14",             :limit => 1
    t.integer "ycy14_datatype",    :limit => 1
    t.integer "ycy15",             :limit => 1
    t.integer "ycy15_datatype",    :limit => 1
    t.integer "ycy16",             :limit => 1
    t.integer "ycy16_datatype",    :limit => 1
    t.integer "ycy17",             :limit => 1
    t.integer "ycy17_datatype",    :limit => 1
    t.integer "ycy18",             :limit => 1
    t.integer "ycy18_datatype",    :limit => 1
    t.integer "ycy19",             :limit => 1
    t.integer "ycy19_datatype",    :limit => 1
    t.integer "ycy20",             :limit => 1
    t.integer "ycy20_datatype",    :limit => 1
    t.integer "ycy21",             :limit => 1
    t.integer "ycy21_datatype",    :limit => 1
    t.integer "ycy22",             :limit => 1
    t.integer "ycy22_datatype",    :limit => 1
    t.integer "ycy23",             :limit => 1
    t.integer "ycy23_datatype",    :limit => 1
    t.integer "ycy24",             :limit => 1
    t.integer "ycy24_datatype",    :limit => 1
    t.integer "ycy25",             :limit => 1
    t.integer "ycy25_datatype",    :limit => 1
    t.integer "ycy26",             :limit => 1
    t.integer "ycy26_datatype",    :limit => 1
    t.integer "ycy27",             :limit => 1
    t.integer "ycy27_datatype",    :limit => 1
    t.integer "ycy28",             :limit => 1
    t.integer "ycy28_datatype",    :limit => 1
    t.integer "ycy29",             :limit => 1
    t.integer "ycy29_datatype",    :limit => 1
    t.string  "ycy29hv"
    t.integer "ycy29hv_datatype",  :limit => 1
    t.integer "ycy30",             :limit => 1
    t.integer "ycy30_datatype",    :limit => 1
    t.integer "ycy31",             :limit => 1
    t.integer "ycy31_datatype",    :limit => 1
    t.integer "ycy32",             :limit => 1
    t.integer "ycy32_datatype",    :limit => 1
    t.integer "ycy33",             :limit => 1
    t.integer "ycy33_datatype",    :limit => 1
    t.integer "ycy34",             :limit => 1
    t.integer "ycy34_datatype",    :limit => 1
    t.integer "ycy35",             :limit => 1
    t.integer "ycy35_datatype",    :limit => 1
    t.integer "ycy36",             :limit => 1
    t.integer "ycy36_datatype",    :limit => 1
    t.integer "ycy37",             :limit => 1
    t.integer "ycy37_datatype",    :limit => 1
    t.integer "ycy38",             :limit => 1
    t.integer "ycy38_datatype",    :limit => 1
    t.integer "ycy39",             :limit => 1
    t.integer "ycy39_datatype",    :limit => 1
    t.integer "ycy40",             :limit => 1
    t.integer "ycy40_datatype",    :limit => 1
    t.string  "ycy40hv"
    t.integer "ycy40hv_datatype",  :limit => 1
    t.integer "ycy41",             :limit => 1
    t.integer "ycy41_datatype",    :limit => 1
    t.integer "ycy42",             :limit => 1
    t.integer "ycy42_datatype",    :limit => 1
    t.integer "ycy43",             :limit => 1
    t.integer "ycy43_datatype",    :limit => 1
    t.integer "ycy44",             :limit => 1
    t.integer "ycy44_datatype",    :limit => 1
    t.integer "ycy45",             :limit => 1
    t.integer "ycy45_datatype",    :limit => 1
    t.integer "ycy46",             :limit => 1
    t.integer "ycy46_datatype",    :limit => 1
    t.string  "ycy46hv"
    t.integer "ycy46hv_datatype",  :limit => 1
    t.integer "ycy47",             :limit => 1
    t.integer "ycy47_datatype",    :limit => 1
    t.integer "ycy48",             :limit => 1
    t.integer "ycy48_datatype",    :limit => 1
    t.integer "ycy49",             :limit => 1
    t.integer "ycy49_datatype",    :limit => 1
    t.integer "ycy50",             :limit => 1
    t.integer "ycy50_datatype",    :limit => 1
    t.integer "ycy51",             :limit => 1
    t.integer "ycy51_datatype",    :limit => 1
    t.integer "ycy52",             :limit => 1
    t.integer "ycy52_datatype",    :limit => 1
    t.integer "ycy53",             :limit => 1
    t.integer "ycy53_datatype",    :limit => 1
    t.integer "ycy54",             :limit => 1
    t.integer "ycy54_datatype",    :limit => 1
    t.integer "ycy55",             :limit => 1
    t.integer "ycy55_datatype",    :limit => 1
    t.integer "ycy56a",            :limit => 1
    t.integer "ycy56a_datatype",   :limit => 1
    t.integer "ycy56b",            :limit => 1
    t.integer "ycy56b_datatype",   :limit => 1
    t.integer "ycy56c",            :limit => 1
    t.integer "ycy56c_datatype",   :limit => 1
    t.integer "ycy56d",            :limit => 1
    t.integer "ycy56d_datatype",   :limit => 1
    t.string  "ycy56dhv"
    t.integer "ycy56dhv_datatype", :limit => 1
    t.integer "ycy56e",            :limit => 1
    t.integer "ycy56e_datatype",   :limit => 1
    t.integer "ycy56f",            :limit => 1
    t.integer "ycy56f_datatype",   :limit => 1
    t.integer "ycy56g",            :limit => 1
    t.integer "ycy56g_datatype",   :limit => 1
    t.integer "ycy56h",            :limit => 1
    t.integer "ycy56h_datatype",   :limit => 1
    t.string  "ycy56hhv"
    t.integer "ycy56hhv_datatype", :limit => 1
    t.integer "ycy57",             :limit => 1
    t.integer "ycy57_datatype",    :limit => 1
    t.integer "ycy58",             :limit => 1
    t.integer "ycy58_datatype",    :limit => 1
    t.string  "ycy58hv"
    t.integer "ycy58hv_datatype",  :limit => 1
    t.integer "ycy59",             :limit => 1
    t.integer "ycy59_datatype",    :limit => 1
    t.integer "ycy60",             :limit => 1
    t.integer "ycy60_datatype",    :limit => 1
    t.integer "ycy61",             :limit => 1
    t.integer "ycy61_datatype",    :limit => 1
    t.integer "ycy62",             :limit => 1
    t.integer "ycy62_datatype",    :limit => 1
    t.integer "ycy63",             :limit => 1
    t.integer "ycy63_datatype",    :limit => 1
    t.integer "ycy64",             :limit => 1
    t.integer "ycy64_datatype",    :limit => 1
    t.integer "ycy65",             :limit => 1
    t.integer "ycy65_datatype",    :limit => 1
    t.integer "ycy66",             :limit => 1
    t.integer "ycy66_datatype",    :limit => 1
    t.string  "ycy66hv"
    t.integer "ycy66hv_datatype",  :limit => 1
    t.integer "ycy67",             :limit => 1
    t.integer "ycy67_datatype",    :limit => 1
    t.integer "ycy68",             :limit => 1
    t.integer "ycy68_datatype",    :limit => 1
    t.integer "ycy69",             :limit => 1
    t.integer "ycy69_datatype",    :limit => 1
    t.integer "ycy70",             :limit => 1
    t.integer "ycy70_datatype",    :limit => 1
    t.string  "ycy70hv"
    t.integer "ycy70hv_datatype",  :limit => 1
    t.integer "ycy71",             :limit => 1
    t.integer "ycy71_datatype",    :limit => 1
    t.integer "ycy72",             :limit => 1
    t.integer "ycy72_datatype",    :limit => 1
    t.integer "ycy73",             :limit => 1
    t.integer "ycy73_datatype",    :limit => 1
    t.integer "ycy74",             :limit => 1
    t.integer "ycy74_datatype",    :limit => 1
    t.integer "ycy75",             :limit => 1
    t.integer "ycy75_datatype",    :limit => 1
    t.integer "ycy76",             :limit => 1
    t.integer "ycy76_datatype",    :limit => 1
    t.integer "ycy77",             :limit => 1
    t.integer "ycy77_datatype",    :limit => 1
    t.integer "ycy78",             :limit => 1
    t.integer "ycy78_datatype",    :limit => 1
    t.integer "ycy79",             :limit => 1
    t.integer "ycy79_datatype",    :limit => 1
    t.string  "ycy79hv"
    t.integer "ycy79hv_datatype",  :limit => 1
    t.integer "ycy80",             :limit => 1
    t.integer "ycy80_datatype",    :limit => 1
    t.integer "ycy81",             :limit => 1
    t.integer "ycy81_datatype",    :limit => 1
    t.integer "ycy82",             :limit => 1
    t.integer "ycy82_datatype",    :limit => 1
    t.integer "ycy83",             :limit => 1
    t.integer "ycy83_datatype",    :limit => 1
    t.string  "ycy83hv"
    t.integer "ycy83hv_datatype",  :limit => 1
    t.integer "ycy84",             :limit => 1
    t.integer "ycy84_datatype",    :limit => 1
    t.string  "ycy84hv"
    t.integer "ycy84hv_datatype",  :limit => 1
    t.integer "ycy85",             :limit => 1
    t.integer "ycy85_datatype",    :limit => 1
    t.string  "ycy85hv"
    t.integer "ycy85hv_datatype",  :limit => 1
    t.integer "ycy86",             :limit => 1
    t.integer "ycy86_datatype",    :limit => 1
    t.integer "ycy87",             :limit => 1
    t.integer "ycy87_datatype",    :limit => 1
    t.integer "ycy88",             :limit => 1
    t.integer "ycy88_datatype",    :limit => 1
    t.integer "ycy89",             :limit => 1
    t.integer "ycy89_datatype",    :limit => 1
    t.integer "ycy90",             :limit => 1
    t.integer "ycy90_datatype",    :limit => 1
    t.integer "ycy91",             :limit => 1
    t.integer "ycy91_datatype",    :limit => 1
    t.integer "ycy92",             :limit => 1
    t.integer "ycy92_datatype",    :limit => 1
    t.integer "ycy93",             :limit => 1
    t.integer "ycy93_datatype",    :limit => 1
    t.integer "ycy94",             :limit => 1
    t.integer "ycy94_datatype",    :limit => 1
    t.integer "ycy95",             :limit => 1
    t.integer "ycy95_datatype",    :limit => 1
    t.integer "ycy96",             :limit => 1
    t.integer "ycy96_datatype",    :limit => 1
    t.integer "ycy97",             :limit => 1
    t.integer "ycy97_datatype",    :limit => 1
    t.integer "ycy98",             :limit => 1
    t.integer "ycy98_datatype",    :limit => 1
    t.integer "ycy99",             :limit => 1
    t.integer "ycy99_datatype",    :limit => 1
    t.integer "ycy100",            :limit => 1
    t.integer "ycy100_datatype",   :limit => 1
    t.string  "ycy100hv"
    t.integer "ycy100hv_datatype", :limit => 1
    t.integer "ycy101",            :limit => 1
    t.integer "ycy101_datatype",   :limit => 1
    t.integer "ycy102",            :limit => 1
    t.integer "ycy102_datatype",   :limit => 1
    t.integer "ycy103",            :limit => 1
    t.integer "ycy103_datatype",   :limit => 1
    t.integer "ycy104",            :limit => 1
    t.integer "ycy104_datatype",   :limit => 1
    t.integer "ycy105",            :limit => 1
    t.integer "ycy105_datatype",   :limit => 1
    t.string  "ycy105hv"
    t.integer "ycy105hv_datatype", :limit => 1
    t.integer "ycy106",            :limit => 1
    t.integer "ycy106_datatype",   :limit => 1
    t.integer "ycy107",            :limit => 1
    t.integer "ycy107_datatype",   :limit => 1
    t.integer "ycy108",            :limit => 1
    t.integer "ycy108_datatype",   :limit => 1
    t.integer "ycy109",            :limit => 1
    t.integer "ycy109_datatype",   :limit => 1
    t.integer "ycy110",            :limit => 1
    t.integer "ycy110_datatype",   :limit => 1
    t.integer "ycy111",            :limit => 1
    t.integer "ycy111_datatype",   :limit => 1
    t.integer "ycy112",            :limit => 1
    t.integer "ycy112_datatype",   :limit => 1
    t.integer "ycyispor",          :limit => 1
    t.integer "ycyispor_datatype", :limit => 1
    t.integer "ycyiaspt",          :limit => 1
    t.integer "ycyiaspt_datatype", :limit => 1
    t.integer "ycyibspt",          :limit => 1
    t.integer "ycyibspt_datatype", :limit => 1
    t.integer "ycyicspt",          :limit => 1
    t.integer "ycyicspt_datatype", :limit => 1
    t.integer "ycyiasp",           :limit => 1
    t.integer "ycyiasp_datatype",  :limit => 1
    t.integer "ycyibsp",           :limit => 1
    t.integer "ycyibsp_datatype",  :limit => 1
    t.integer "ycyicsp",           :limit => 1
    t.integer "ycyicsp_datatype",  :limit => 1
    t.integer "ycyiaht",           :limit => 1
    t.integer "ycyiaht_datatype",  :limit => 1
    t.integer "ycyiah",            :limit => 1
    t.integer "ycyiah_datatype",   :limit => 1
    t.integer "ycyibh",            :limit => 1
    t.integer "ycyibh_datatype",   :limit => 1
    t.integer "ycyibht",           :limit => 1
    t.integer "ycyibht_datatype",  :limit => 1
    t.integer "ycyicht",           :limit => 1
    t.integer "ycyicht_datatype",  :limit => 1
    t.integer "ycyich",            :limit => 1
    t.integer "ycyich_datatype",   :limit => 1
    t.integer "ycyiiia",           :limit => 1
    t.integer "ycyiiia_datatype",  :limit => 1
    t.integer "ycyiiib",           :limit => 1
    t.integer "ycyiiib_datatype",  :limit => 1
    t.integer "ycyiiic",           :limit => 1
    t.integer "ycyiiic_datatype",  :limit => 1
    t.integer "ycyivja",           :limit => 1
    t.integer "ycyivja_datatype",  :limit => 1
    t.integer "ycyivjb",           :limit => 1
    t.integer "ycyivjb_datatype",  :limit => 1
    t.integer "ycyivjc",           :limit => 1
    t.integer "ycyivjc_datatype",  :limit => 1
    t.integer "yaviian1",          :limit => 1
    t.integer "yaviian1_datatype", :limit => 1
    t.integer "yaviian2",          :limit => 1
    t.integer "yaviian2_datatype", :limit => 1
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
