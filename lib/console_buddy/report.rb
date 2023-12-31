# frozen_string_literal: true

require 'table_print'
require 'terminal-table'

# Example:
# 
# ConsoleBuddy::Report.table_print(User.all, "username")
# 
# 
# Example 2:
# 
# table_print User.all, "username"
# 
# 
module ConsoleBuddy
  module Report
    def table_print(data, options = {})
      puts ::TablePrint::Printer.table_print(data, options)
    end
    alias print_data table_print

    def table_for(rows, headers = [])
      table = ::Terminal::Table.new(headings: headers, rows: rows)
      puts table
    end
  end
end
