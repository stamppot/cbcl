module ThinkingSphinx
  class Source
    module SQL
      # Generates the big SQL statement to get the data back for all the fields
      # and attributes, using all the relevant association joins. If you want
      # the version filtered for delta values, send through :delta => true in the
      # options. Won't do much though if the index isn't set up to support a
      # delta sibling.
      #
      # Examples:
      #
      #   source.to_sql
      #   source.to_sql(:delta => true)
      #
      def to_sql(options={})
        sql = "SELECT "
        sql += "SQL_NO_CACHE " if adapter.sphinx_identifier == "mysql"
        sql += <<-SQL
        #{ sql_select_clause options[:offset] }
        FROM #{ @model.quoted_table_name }
        #{ all_associations.collect { |assoc| assoc.to_sql }.join(' ') }
        #{ sql_where_clause(options) }
        GROUP BY #{ sql_group_clause }
        SQL

        sql += " ORDER BY id desc" if adapter.sphinx_identifier == "mysql"
        sql
      end

      # Simple helper method for the query range SQL - which is a statement that
      # returns minimum and maximum id values. These can be filtered by delta -
      # so pass in :delta => true to get the delta version of the SQL.
      #
      def to_sql_query_range(options={})
        return nil if @index.options[:disable_range]
        if !options[:delta] and self.delta?
          #SELECT Min(id), Max(id) FROM sos WHERE id <= (SELECT last_id FROM sph_counter WHERE table_name = 'sos')
          min_statement = adapter.convert_nulls(
            "MIN(#{quote_column(@model.primary_key_for_sphinx)})", 1
          )
          max_statement = adapter.convert_nulls(
            "MAX(#{quote_column(@model.primary_key_for_sphinx)})", 1
          )

          sql = "SELECT #{min_statement}, #{max_statement} " +
            "FROM #{@model.quoted_table_name} WHERE #{@model.primary_key_for_sphinx} <= (SELECT last_id FROM sph_counter WHERE table_name = '#{@model.table_name}')"
        else


          min_statement = adapter.convert_nulls(
            "MIN(#{quote_column(@model.primary_key_for_sphinx)})", 1
          )
          max_statement = adapter.convert_nulls(
            "MAX(#{quote_column(@model.primary_key_for_sphinx)})", 1
          )

          sql = "SELECT #{min_statement}, #{max_statement} " +
            "FROM #{@model.quoted_table_name} "

          if self.delta?
            #sql_query_range = SELECT Min(id), Max(id) FROM sos WHERE id > (SELECT last_id FROM sph_counter WHERE table_name = 'sos')
            sql +=  "WHERE #{@model.primary_key_for_sphinx} > (SELECT last_id FROM sph_counter WHERE table_name = '#{@model.table_name}')"
          end

        end
        sql
      end

      # Simple helper method for the query info SQL - which is a statement that
      # returns the single row for a corresponding id.
      #
      def to_sql_query_info(offset)
        "SELECT * FROM #{@model.quoted_table_name} WHERE " +
          "#{quote_column(@model.primary_key_for_sphinx)} = (($id - #{offset}) / #{ThinkingSphinx.context.indexed_models.size})"
          end

      def sql_select_clause(offset)
        unique_id_expr = ThinkingSphinx.unique_id_expression(offset)

        (
          ["#{@model.quoted_table_name}.#{quote_column(@model.primary_key_for_sphinx)} #{unique_id_expr} AS #{quote_column(@model.primary_key_for_sphinx)} "] +
          @fields.collect     { |field|     field.to_select_sql     } +
          @attributes.collect { |attribute| attribute.to_select_sql }
        ).compact.join(", ")
      end

      def sql_where_clause(options)
        logic = []
        logic += [
          "#{@model.quoted_table_name}.#{quote_column(@model.primary_key_for_sphinx)} >= $start",
          "#{@model.quoted_table_name}.#{quote_column(@model.primary_key_for_sphinx)} <= $end"
        ] unless @index.options[:disable_range]

        # if self.delta? && !@index.delta_object.clause(@model, options[:delta]).blank?
        #          logic << "#{@index.delta_object.clause(@model, options[:delta])}"
        #        end

        logic += (@conditions || [])
        logic.empty? ? "" : "WHERE #{logic.join(' AND ')}"
      end

      def sql_group_clause
        internal_groupings = []
        if @model.column_names.include?(@model.inheritance_column)
          internal_groupings << "#{@model.quoted_table_name}.#{quote_column(@model.inheritance_column)}"
        end

        (
          ["#{@model.quoted_table_name}.#{quote_column(@model.primary_key_for_sphinx)}"] +
          @fields.collect     { |field|     field.to_group_sql     }.compact +
          @attributes.collect { |attribute| attribute.to_group_sql }.compact +
          @groupings + internal_groupings
        ).join(", ")
      end

      def sql_query_pre_for_core
        if !options[:delta] and self.delta?
          #REPLACE INTO sph_counter SELECT 'sos', Max(id) FROM sos
          ["REPLACE INTO sph_counter SELECT '#{@model.table_name}', Max(id) FROM #{@model.quoted_table_name}"]
        else
          []
        end
      end

      def sql_query_pre_for_delta
        [""]
      end

      def quote_column(column)
        @model.connection.quote_column_name(column)
      end

      def crc_column
        if @model.table_exists? &&
            @model.column_names.include?(@model.inheritance_column)

          adapter.cast_to_unsigned(adapter.convert_nulls(
                                     adapter.crc(adapter.quote_with_table(@model.inheritance_column), true),
                                     @model.to_crc32
          ))
        else
          @model.to_crc32.to_s
        end
      end
    end
  end
end
