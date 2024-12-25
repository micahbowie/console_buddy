require 'spec_helper'
require 'csv'
require 'fileutils'
require 'tempfile'
require_relative '../../lib/console_buddy/csv'

RSpec.describe ConsoleBuddy::CSV do
  include ConsoleBuddy::CSV

  describe '#generate_csv' do
    let(:headers) { ['Name', 'Age'] }
    let(:rows) { [['Alice', "30"], ['Bob', "25"]] }
    let(:dir) { 'tmp' }
    let(:filename) { 'test_csv' }
    let(:file_path) { File.join(dir, "#{filename}.csv") }

    before do
      FileUtils.mkdir_p(dir)
    end

    after do
      FileUtils.rm_rf(dir)
    end

    it 'creates a CSV file with the given headers and rows' do
      generate_csv(headers, rows, filename: filename, dir: dir)
      expect(File).to exist(file_path)

      csv_content = ::CSV.read(file_path)
      expect(csv_content).to eq([headers, *rows])
    end

    it 'creates the directory if it does not exist' do
      new_dir = 'new_tmp'
      new_file_path = File.join(new_dir, "#{filename}.csv")

      generate_csv(headers, rows, filename: filename, dir: new_dir)
      expect(File).to exist(new_file_path)

      csv_content = ::CSV.read(new_file_path)
      expect(csv_content).to eq([headers, *rows])

      FileUtils.rm_rf(new_dir)
    end
  end

  describe '#read_csv' do
    let(:headers) { ['Name', 'Age'] }
    let(:rows) { [['Alice', "30"], ['Bob', "25"]] }
    let(:tempfile) { Tempfile.new(['test_csv', '.csv']) }

    before do
      ::CSV.open(tempfile.path, 'w') do |csv|
        csv << headers
        rows.each { |row| csv << row }
      end
    end

    after do
      tempfile.close
      tempfile.unlink
    end

    it 'reads the CSV file and returns the data without headers' do
      data = read_csv(tempfile.path, skip_headers: true)
      expect(data.count).to eq(rows.count)
    end

    it 'reads the CSV file and returns the data with headers' do
      data = read_csv(tempfile.path, skip_headers: false)
      expect(data).to eq([headers, *rows])
    end
  end
end