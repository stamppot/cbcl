
class ScoreTitle < ScoreReport
  
  attr_accessor :title, :survey_name, :short_name, :score, :scale, :scores, :result, :percentile, :description
  
  def initialize(title = "", scale = 0)
    @title = title
    @scale = scale
    @result = 0
  end
  
  def to_s
    if self.title == "tom"
      ""
    else
    "<div class='scale_title'>" +
      @title.to_s + "</div>" + 
      "<a class='show_hide' HREF='javascript:toggleElems(&quot;scale_#{@scale}&quot;)' >" + #  
      "<img border='0' src='/images/icon_show_hide.png' /></a>"    
    end
  end
end