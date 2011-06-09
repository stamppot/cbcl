class CreateCodeBooks < ActiveRecord::Migration
  def self.up
 
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
    t.string  "measure"
    t.integer "row",               :null => false
    t.integer "col",               :null => false
    t.integer "item_choice_id",    :null => false
  end
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
  end

  def self.down
    drop_table :item_options
    drop_table :item_choices
    drop_table :codes
    drop_table :code_books
  end
end
