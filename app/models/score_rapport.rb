class ScoreRapport < ActiveRecord::Base
  has_many :score_results, :dependent => :delete_all
  belongs_to :journal_entry
  belongs_to :survey_answer
  belongs_to :survey

  def to_xml(options = {})
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new
      #xml.instruct!
      xml.__send__(:score_rapport, {:survey => self.survey_name, :survey_short => self.short_name, :unanswered => self.unanswered}) do
      # xml.score_rapport do
        # xml.survey self.survey_name
        # xml.survey_short self.short_name
        # xml.unanswered self.unanswered
        self.score_results.each do |result|
          xml.title result.title
          xml.result result.result
          xml.mean result.mean
          xml.percentile98 true if result.percentile_98
          xml.percentile95 true if result.percentile_95
        end
      end
    end
  end
  
end