require 'db/migration_helpers'

class CreateFaq < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :faq_sections do |t|
      t.string :title
      t.integer :position
    end
    create_table :faqs do |t|
      t.integer :faq_section_id, :position
      t.string :question, :answer, :title
      t.index :fag_section_id
    end
    add_foreign_key('faqs', 'fk_faqs_faq_sections', 'faq_section_id', 'faq_sections', 'id')
  end

  def self.down
    drop_table :faqs if table_exists? :faqs
    drop_table :faq_sections if table_exists? :faq_sections
  end
end
