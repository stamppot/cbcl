class SumScoreGroups
  attr_accessor :score_groups, :score_rapports, :grouped_values

  def read_values(score_results)
    self.score_rapports = score_results.group_by {|sr| sr.score}
    self.grouped_values = {}
    self.score_rapports.each do |score_id, rapports|
      self.grouped_values[score_id] = rapports.map { |r| r.result }.to_scale
    end
  end

  def calculate_scores
    sum_scores = []
    self.grouped_values.each do |score_id, values|
      sumscore = SumScore.new
      sumscore.score = score_id
      sumscore.values = values
      sumscore.mean = values.mean
      sumscore.deviation = values.sd
      sumscore.z_scores
      sumscore.q_scores
      sum_scores << sumscore
    end
    sum_scores
  end
end