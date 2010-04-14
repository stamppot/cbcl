class ScoreItem < ActiveRecord::Base
    belongs_to :score
    belongs_to :question
    
    # todo check for nil... or make sure self.qualifier is never nil
    def item_qualifier
      self.score.item_qualifiers.invert[self.qualifier]
    end
    
    def calculate(survey_answer)
      # find answer to calculate result for
      answer = survey_answer.answers.detect {|answer| answer.question_id == self.question_id }
      not_answered = []
      result = ""
      points = 0

      # extract items to work on
      return nil unless answer  # guard clause
      
      s_items = self.qualified_cells(answer)   # chosen cells from answer  # TODO htuneohtnuao
      s_items = s_items.select {|a| !a.value.blank? }  # count only non-blank answer_cells
      surveytype = self.score.survey.surveytype
      hits = s_items.size
      # answered_items = s_items.map {|ac| ac.item }.join(",")
      missing = self.score.items_count - hits

      if self.score.sum_type == "normal"     # normal
        s_items.each { |item| points += item.value.to_i if ((1..8) === item.value.to_i) } # and (item.class == Rating)
      elsif self.score.sum_type == "dicotomi"  # dicotomi
        s_items.each { |item| points += 1 if (1..8) === item.value.to_i } # do not count '9' or '88' values
      end
      return [points, missing, hits, ]
    end


    # returns list of qualified items, when taking qualifiers into account
    def qualified_cells(answer)
      score_items = []
      cells = []
      found_cells = []
      
      # count only ratings
      a_cells = answer.ratings
      
      if self.item_qualifier == "valgte"
        score_items = self.items.gsub(/\s+/, "").split(',')  # only numbers, no cells
        idx_cells = a_cells.inject({}) { |col, a_cell| col[a_cell.item] = a_cell; col }
        score_items.each do |s_item|
          found_cell = idx_cells[s_item] #a_cells.detect { |a_cell| a_cell.item.to_s == s_item }
          found_cells << found_cell if found_cell
        end
      else # self.item_qualifier == "alle"                   # both options needs to find all cells
        found_cells = a_cells                                # get all items
        if self.item_qualifier == "undtaget"                 # remove excepted items
          found_cells = a_cells.inject({}) do |col, a_cell|  # build an index of items to remove
            col[a_cell.item] = a_cell; col
          end
          remove_items = self.items.gsub(/\s+/, "").split(',')
          remove_items.each { |remove_item| found_cells.delete(remove_item) }
          found_cells = found_cells.values
        end      
      end
      return found_cells
    end


    private
    
    # def default_item_qualifiers
    #   {
    #     'valgte'   => 0,
    #     'alle'     => 1,
    #     'undtaget' => 2
    #   }
    # end
end
  
