require 'statsample'

class ZScoreGroup
  attr_accessor :score_results, :age_group, :gender, :sum_score, :ages, :title, :scale

  def initialize(options)
    self.age_group = options[:age_group] if options[:age_group]
    self.gender = options[:gender] if options[:gender]
    # self.age = options[:age] if options[:age]
    self.score_results = []
    self.ages = []
    # self.sum_score = SumScore.new
  end

  def self.group_by_score(score_results)
    score_groups = score_results.inject({}) do |col,res|
      col[res.score] ||= []
      col[res.score] << res
      col
    end
  end

  # also removes empty results
  def self.partition_by_gender(score_results)
    male = []
    female = []
    puts "partition_by_gender: #{score_results.size}"
    score_results.each do |sr|
      next unless sr.valid_percentage    # over 10% missing * i givet fald beregnes sumscoren ikke
      sr.result = 0 if sr.result.blank?  # med hensyntagen til at missing data defineres til "0" med mindre der er over 10% missing * i givet fald beregnes sumscoren ikke
      male << sr if sr.score_rapport.gender == 1
      female << sr if sr.score_rapport.gender == 2
    end
    return [male, female]
  end


  # TODO: the score_results given should be for a specific score (fx adhd el. external). Her beregnes z_scores inden for denne score
  # returns array of ZScoreGroups
  def self.partition_in_gender_and_age_groups(score_results)
    # group score_results by score
    score_groups = self.group_by_score(score_results)

    groups = [] #{}
    score_groups.each do |score, results|
      m, f = self.partition_by_gender(results)

      # divide into groups of gender, age group 
      male_groups = m.inject({}) do |mgroups, rs|
        sr = rs.score_rapport
        scale = rs.score_scale && rs.score_scale.title || ""
        # mgroups[sr.age_group] ||= ZScoreGroup.new(:age_group => sr.age_group, :gender => :male, :title => rs.title)
        # mgroups[sr.age_group].score_results << rs
        # mgroups[sr.age_group].ages << sr.age
        puts "age: #{sr.age_group} gender: #{:male} title: #{rs.title} scale: #{scale}"
        mgroups[score.id] ||= ZScoreGroup.new(:age_group => sr.age_group, :gender => :male, :title => rs.title, :scale => scale)
        puts "no rapport for: #{rs.inspect}" unless sr
        mgroups[score.id].title ||= rs.title
        mgroups[score.id].scale ||= scale
        mgroups[score.id].score_results << rs
        mgroups[score.id].ages << sr.age
        mgroups
      end
      # calculate z-scores
      # male_groups.each do |key_age_group, zscoregroup|
      #   zscoregroup.sum_score.values = zscoregroup.score_results.map{|r| r.result}.to_scale
      #   zscoregroup.sum_score.calc_z_scores
      #   groups["m_#{key_age_group}"] = zscoregroup
      # end
      male_groups.each do |score_id, zscoregroup|
        zscoregroup.sum_score = SumScore.new
        zscoregroup.sum_score.values = zscoregroup.score_results.map{|r| r.result}.to_scale
        zscoregroup.sum_score.calc_z_scores
        # groups["m_#{key_age_group}"] ||= []
        # groups["m_#{key_age_group}"] << zscoregroup
        groups << zscoregroup
      end

      # puts "male results: #{male_groups.values.size}"
      female_groups = m.inject({}) do |fgroups, rs|
        sr = rs.score_rapport
        scale = sr.score_scale && sr.score_scale.title || ""
        # fgroups[sr.age_group] ||= ZScoreGroup.new(:age_group => sr.age_group, :gender => :female, :title => rs.title)
        # fgroups[sr.age_group].score_results << rs
        # fgroups[sr.age_group].ages << sr.age
        fgroups[score.id] ||= ZScoreGroup.new(:age_group => sr.age_group, :gender => :female, :title => rs.title, :scale => scale)
        fgroups[score.id].title ||= rs.title
        fgroups[score.id].scale ||= scale
        fgroups[score.id].score_results << rs
        fgroups[score.id].ages << sr.age
        fgroups
      end
      # calculate z-scores
      # female_groups.each do |key_age_group, zscoregroup|
      #   zscoregroup.sum_score.values = zscoregroup.score_results.map{|r| r.result}.to_scale
      #   zscoregroup.sum_score.calc_z_scores
      #   groups["f_#{key_age_group}"] = zscoregroup
      # end
      female_groups.each do |score_id, zscoregroup|  # hash: score_id => ZScoreGroup
        zscoregroup.sum_score = SumScore.new
        zscoregroup.sum_score.values = zscoregroup.score_results.map{|r| r.result}.to_scale
        zscoregroup.sum_score.calc_z_scores
        groups << zscoregroup
      end
    end
    groups
  end

  def to_s
    "ZScoreGroup. Gender: #{gender}. Age group: #{age_group}"
  end

  def self.to_xml(score_results)
    groups = self.partition_in_gender_and_age_groups(score_results)

    # if options[:builder]
    # build_xml(options[:builder])
    # else
    xml = Builder::XmlMarkup.new
    #xml.instruct!
    xml.__send__(:z_scores) do
      groups.each do |zscoregroup|
        xml.group({:age_group => zscoregroup.age_group, :gender => zscoregroup.gender, :title => zscoregroup.title, :scale => zscoregroup.scale, :mean => zscoregroup.sum_score.mean, 
          :deviation => zscoregroup.sum_score.deviation, :n => zscoregroup.sum_score.values.size}) do
            zscoregroup.sum_score.values.each_with_index do |i,value|
              xml.val({
                :value => zscoregroup.sum_score.values[i],
                :z => zscoregroup.sum_score.z_scores[i], 
                :t => zscoregroup.sum_score.t_scores[i], 
                :age => zscoregroup.ages[i] 
                })
              end
            end
          end
        end
      end
    end