require 'spec_helper'
require 'table_print'
require 'terminal-table'
require_relative '../../lib/console_buddy/report'

RSpec.describe ConsoleBuddy::Report do
  include ConsoleBuddy::Report

  describe '#table_print' do
    let(:data) { [{ username: 'user1' }, { username: 'user2' }] }
    let(:options) { { columns: [:username] } }

    it 'prints the table using TablePrint' do
      expect(::TablePrint::Printer).to receive(:table_print).with(data, options)
      table_print(data, options)
    end
  end

  describe '#table_for' do
    let(:rows) { [['foo', 'bar'], ['baz', 'qux']] }
    let(:headers) { ['col1', 'col2'] }

    it 'prints the table using Terminal::Table' do
      table = ::Terminal::Table.new(headings: headers, rows: rows)
      expect(::Terminal::Table).to receive(:new).with(headings: headers, rows: rows).and_return(table)
      expect { table_for(rows, headers) }.to output("#{table}\n").to_stdout
    end
  end
end