class Numeric
  def square ; self * self ; end
end

class Array
  def sum
    self.inject(0) {|a,x| x+a }
  end
  def mean
    self.sum.to_f/self.size
  end
  def median
    case self.size % 2
    when 0 then self.sort[self.size/2-1,2].mean
    when 1 then self.sort[self.size/2].to_f
    end if self.size > 0
  end
  def histogram
    self.sort.inject({}) { |a,x| a[x] = a[x].to_i+1; a }
  end
  def mode
    map = self.histogram
    max = map.values.max
    map.keys.select{|x|map[x]==max}
  end
  def squares
    self.inject(0) { |a,x| x.square+a }
  end
  def variance
    self.squares.to_f/self.size - self.mean.square
  end
  def deviation
    Math::sqrt( self.variance )
  end
  def permute
    self.dup.permute!
  end
  def permute!
    (1...self.size).each do |i| ; j=rand(i+1)
      self[i],self[j] = self[j],self[i] if i!=j
    end;self
  end
  def sample n=1 ; (0...n).collect{ self[rand(self.size)] } ; end
end

class StatisticsHelper  # helper for score_result objects
  
  
  def results(score_id = 4)
    values = ScoreResult.all(:conditions => ['score_id = ?', score_id], :select => 'result').map &:result
  end
  
  
  def means(values)
    means = values.mean
    puts "Mean: #{mean.inspect}"
    median = value.median
    puts "Median: #{median.inspect}"
    histogram = values.histogram
    puts "Histogram: #{histogram.inspect}"
    mode = values.mode
    puts "Mode: #{mode.inspect}"
    squares = values.squares
    puts "Squares: #{squares.inspect}"
    variance = values.variance
    puts "Variance: #{variance.inspect}"
    sample = values.sample
    puts "Sample: #{sample.inspect}"
  end
end