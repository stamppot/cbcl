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