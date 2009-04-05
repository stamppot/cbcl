class Faq < ActiveRecord::Base
  belongs_to :faq_section
  acts_as_list :scope => :faq_section

  def Faq::find_question(query = "", language = "en")
    
    lang = case language
    when /en/: { 'title' => 10.0 }
    when /nl/: { 'title2' => 10.0 }
    when /fr/: { 'title3' => 10.0 }
    when /de/: { 'title4' => 10.0 }
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
