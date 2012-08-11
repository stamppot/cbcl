class Faq < ActiveRecord::Base
  belongs_to :faq_section
  acts_as_list :scope => :faq_section

  def Faq::find_question(query = "", language = "en")
    
    lang = case language
    when /en/ then { 'title' => 10.0 }
    when /nl/ then { 'title2' => 10.0 }
    when /fr/ then { 'title3' => 10.0 }
    when /de/ then { 'title4' => 10.0 }
    else
      { 'title' => 10.0 }
    end

    options = {
              :per_page => 10,
              :page => 1,
              :conditions => {},
              :with => {},
              :match_mode => :any,
              :include => [:faq_section]
              }
    
    Faq.search(query, options)
  end

end
