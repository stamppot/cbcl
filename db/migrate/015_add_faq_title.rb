class AddFaqTitle < ActiveRecord::Migration
  def self.up
    add_column :faqs, :title, :string
  end

  def self.down
    remove_column :faqs, :title
  end
end
