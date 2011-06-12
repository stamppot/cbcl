module ModelMixins
  module SurveyAnswer
    module Export

      # obsoleted. Was used to create variables where none exists
      def create_default_variables(prefix = nil, variables = nil)
        variables ||= Variable.all_in_hash(:by => 'question_id', :conditions => ['question_id = ?', self.question_id])
        cells = Dictionary.new
        prefix = survey_answer.survey.prefix unless prefix
        q = self.question.number.to_roman.downcase

        self.answer_cells.each_with_index do |cell, i|
          value = cell.value.blank? && '#NULL!' || cell.value
          if var = get_var(self.question_id, cell.row, cell.col, variables) #Variable.get_by_question(self.question_id, cell.row, cell.col)
            cells[var.var.to_sym] = value
          else  # default var name
            answer_type = cell.answer_type
            item = cell.item || ""

            item << "hv" if (item.nil? or !(item =~ /hv$/)) && cell.text?

            var = "#{prefix}#{q}#{item}".to_sym
            cells[var] = 
            if cell.text? && !cell.value_text.blank?
              CGI.unescape(cell.value_text).gsub(/\r\n?/, ' ').strip
            else
              value
            end
          end
        end
        return cells
      end
      

      def cell_values(prefix = nil, variables = nil)
        variables ||= Variable.all_in_hash(:by => 'question_id', :conditions => ['survey_id = ?', self.survey_id])
        prefix ||= self.survey.prefix
        a = Dictionary.new
        self.answers.each { |answer| a.merge!(answer.cell_values(prefix, variables[answer.question_id])) }
        a.order_by
      end

      def cell_vals(prefix = nil)
        prefix ||= self.survey.prefix
        self.answers.inject([]) { |col, answer| col << (answer.cell_vals(prefix)); col }
      end

      def export_variables_params(journal_info, variables = nil)
        result = Dictionary.new
        result[:export_journal_info_id] = journal_info && journal_info.id || nil
        result[:journal_id] = self.journal_id
        result[:survey_answer_id] = self.id
        if journal_info.nil? || journal.nil?
          puts "Export_variables_params: JournalInfo: #{journal_info.inspect} journal: #{journal.inspect}"
        end
        result.merge!(variables_with_answers(variables))
      end

      def variables_with_answers(variables = nil)
        variables ||= Variable.for_survey(survey_id)
        answer_cells = answer_cells_in_hash
        variables.inject(Dictionary.new) do |col, var|
          cell = get_cell(var, answer_cells)
          col[var.var.to_sym] = if !cell
            nil
          elsif
            cell.text? && !cell.value_text.blank?
            CGI.unescape(cell.value_text).gsub(/\r\n?/, ' ').strip
          else
            cell.value
          end
          col
        end    
      end

      def get_cell(variable, cells_by_row_and_col)
        if cells_by_row_and_col[variable.question_id] && (the_row = cells_by_row_and_col[variable.question_id][variable.row])
          var = the_row[variable.col]
        end
      end

      # same as below but not dependent on answer
      def answer_cells_in_hash(options = {})
        by_id = options.delete(:by) || :question_id
        answers.inject({}) {|h,a| h[a.send(by_id)] = a.answer_cells.build_hash {|ac| [ac.row, {ac.col => ac}] }; h }
      end
      
      
      # csv and xml
      def make_csv_answer
        c = CSVHelper.new
        c.generate_csv_answer_line(c.survey_answer_csv_query)
      end

      def create_csv_answer!
        CSVHelper.new.create_survey_answer_csv(self)
      end

      def self.create_csv_answers!
        CSVHelper.new.generate_all_csv_answers
      end

      def to_xml(options = {})
        if options[:builder]
          build_xml(options[:builder])
        else
          xml = Builder::XmlMarkup.new
          xml.__send__(:survey_answer, {:created => self.created_at}) do
            xml.answers do
              # self.rapports.map(&:score_rapports).each do |rapport|
              self.cell_vals.each do |answer_vals|
                xml.__send__(:answer, {:number => answer_vals[:number]}) do
                  xml.cells do
                    answer_vals[:cells].each do |cell_h|
                      attrs = {:v => cell_h[:v], :var => cell_h[:var], :type => cell_h[:type] }
                      xml.__send__(:cell, attrs)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
