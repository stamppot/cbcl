class ScoreReport
  
  attr_accessor :title, :survey_name, :short_name, :score, :scale, :scores, :result, :percentile, :description
  
  def initialize
    @scores = []
    @survey_name = ""
    @short_name = ""
    @result = 0
    @scale = 0
    @title = ""
    @percentile = ""
    @description = ""
  end
  
  def to_s
    if @score.nil?
      @description = 'link'
      "<div class='scale_title'>#{@title}</div><a class='show_hide' HREF='javascript:toggleElems(&quot;scale_#{@scale}&quot;)'><img border='0' src='/images/icon_show_hide.png' /></a>"
    else
      @result.to_s
    end
  end
  
  # combines a row of score reports to one report
  def combine(row)
    self.scores = row.map { |cell| cell.score }
    return [self]
  end
end
