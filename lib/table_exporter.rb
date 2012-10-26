require 'fastercsv'
require 'to_xls'
# require 'to_xls/writer.rb'
require 'axlsx'

class TableExporter

  # include Axlsx::Ar

  def to_csv(rows, separator = ";")
    csv = FasterCSV.generate(:col_sep => separator, :row_sep => :auto) do |csv|
      headers = rows.shift
      csv << headers
      rows.each { |row| csv << row }
    end
    csv
  end

  def to_excel(table_array)
  	table_array.to_xls
  end

  def to_xlsx(headers, rows, sheet_name = "Sheet")
    row_style = options.delete(:style)
    header_style = options.delete(:header_style) || row_style
    types = [options.delete(:types) || []].flatten

    # i18n = options.delete(:i18n) || self.xlsx_i18n
    columns = headers # options.delete(:columns) || self.xlsx_columns

    p = options.delete(:package) || Package.new
    row_style = p.workbook.styles.add_style(row_style) unless row_style.nil?
    header_style = p.workbook.styles.add_style(header_style) unless header_style.nil?

    return p if rows.empty?
    p.workbook.add_worksheet(:name => sheet_name) do |sheet|
      
      col_labels = #if i18n
                   #  columns.map { |c| I18n.t("#{i18n}.#{self.name.underscore}.#{c}") }                         
                   #else
                     columns.map { |c| c.to_s.humanize }
                   #end
      
      sheet.add_row col_labels, :style=>header_style
      
      rows.each do |r|
        row_data = r.values
         # columns.map do |c|
         #  if c.to_s =~ /\./
         #    v = r; c.to_s.split('.').each { |method| v = v.send(method) }; v
         #  else
         #    r.send(c)                
         #  end
        sheet.add_row row_data, :style=>row_style, :types=>types
      end
    end
    p
  end
end