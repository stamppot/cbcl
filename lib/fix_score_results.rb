ScoreResult.find_in_batches do |results| 
  results.each do |res| 
    if res.score.nil?
      r = res.title[0..2]
      score = Score.find_by_survey_id(res.survey_id, :conditions => ["title LIKE ?", r + '%'])
      if score
        res.save
      else
        res.destroy
      end
    end
  end
end

# update scores.variable
Score.all.each do |score|
  pre = score.survey.prefix
  varname = pre + score.title[0..4].downcase
  
  if(score.title =~ /^Gennem/)
    varname = pre + "udvfo"
  elsif score.title =~ /^ADHD/
    varname = pre + "adhd"
  elsif score.title =~ /^Oppo/
    varname = pre + "opadf"
  elsif score.title =~ /^Adf/
    varname = pre + "adfa" 
  end
  score.variable ||= varname
  score.save
  puts varname
end