module SurveyHelper

  SURVEY_TYPES = [ ["Lærer", "teacher"], ["Forælder", "parent"], ["Ung", "youth"], ["Pædagog", "pedagogue"], ["Andet", "other"] ]

  def div_item(html, type)
    #content_tag("div", html, { :class => type } )
    "<div class='#{type}'>#{html}</div>"
  end

  def set_focus_to_id(id)
    javascript_tag("$('#{id}').focus()");
  end
  
  # help is form needing help
  # used by answer_by question
  def help_tip(help, div_id)
    "<div id='help_#{div_id}' class='comment' style='display:none;'><div class='help_tip'>#{help}</div></div>" <<
    (link_to_function( "<img src='/images/icon_comment.gif' border=0 title='hjælp' />",
        update_page { |page| page.toggle("help_#{div_id}") }))
    end
end
