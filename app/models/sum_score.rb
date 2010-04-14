# for an array of values, calculates variance, deviation, T-score, Z-score (standard score), etc
# input initializers: input: collection of score_rapports. These are divided into groups of each score

# this class holds the calculated values for a given group

require 'statsample'
# require 'facets'

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

class SumScore
  attr_accessor :values  # all results for a given score
  attr_accessor :score  # score objs
  attr_accessor :z_scores
  attr_accessor :t_scores
  attr_accessor :q_scores
  attr_accessor :mean, :deviation, :variance

  alias_method :sd, :deviation

  Z_MAX = 6
  # ROUND_FLOAT = 0.0000001 # 6 decimals

  def calc_z_scores # calculate all z-scores
    self.deviation ||= values.sd
    self.mean ||= values.mean
    self.z_scores = values.map { |v| ((v-mean)/deviation).round(4) }
    self.t_scores = self.z_scores.map { |z| 10*z + 50 }
    self.deviation = self.deviation.round(4) # round after using more precise number for calculation
    self.mean = self.mean.round(4)
    self.z_scores
    # q_scores = z_scores.map { |z| calc_q_from_z(z) }
  end

  def calc_q_scores # calculate all z-scores
    self.deviation ||= values.sd
    self.mean ||= values.mean
    self.z_scores ||= self.values.map { |v| (v-mean)/deviation }
    self.deviation = self.deviation.round(4) # round after using more precise number for calculation
    self.mean = self.mean.round(4)
    self.q_scores = self.z_scores.map { |z| calc_q_from_z(z) }
  end


  private

  def calc_q_from_z(value)
    if (value.abs > Z_MAX)
      -1 # "Error: z value must be between -6 and 6.\nValues outside this range have probabilities\nwhich exceed the precision of calculation used in this page."
    else
      qz = 1 - poz(value)
      value = qz #.round_to(ROUND_FLOAT)
    end
  end

  def poz(z)
    y = 0.0
    x = 0.0
    # w = 0.0

    if (z == 0.0)
      x = 0.0
    else
      y = 0.5 * z.abs
      if (y > (Z_MAX * 0.5))
        x = 1.0
      elsif (y < 1.0)
        w = y * y
        x = ((((((((0.000124818987 * w
        - 0.001075204047) * w + 0.005198775019) * w
        - 0.019198292004) * w + 0.059054035642) * w
        - 0.151968751364) * w + 0.319152932694) * w
        - 0.531923007300) * w + 0.797884560593) * y * 2.0
      else
        y -= 2.0
        x = (((((((((((((-0.000045255659 * y
        + 0.000152529290) * y - 0.000019538132) * y
        - 0.000676904986) * y + 0.001390604284) * y
        - 0.000794620820) * y - 0.002034254874) * y
        + 0.006549791214) * y - 0.010557625006) * y
        + 0.011630447319) * y - 0.009279453341) * y
        + 0.005353579108) * y - 0.002141268741) * y
        + 0.000535310849) * y + 0.999936657524
      end
    end
    return z > 0.0 ? ((x + 1.0) * 0.5) : ((1.0 - x) * 0.5)
  end
end  
