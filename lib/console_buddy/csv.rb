# frozen_string_literal: true

require 'csv'

module ConsoleBuddy
  module CSV
    def generate_csv(headers, rows, filename: DateTime.now.to_s, dir: 'tmp')
      if dir == 'tmp'
        Dir.mkdir(dir) unless Dir.exist?(dir)
      end
      file_path = ::File.join(dir, "#{file_name}.csv")

      ::CSV.open(file_path, 'w') do |csv|
        csv << headers
        rows.each do |row|
          csv << row
        end
      end

      puts "CSV created. CSV can be found at: #{file_path}"
    end

    def read_csv(file_path, skip_headers: true)
      data = []
      ::CSV.foreach(file_path, headers: skip_headers) do |row|
        data << row
      end
      data
    end
  end
end
