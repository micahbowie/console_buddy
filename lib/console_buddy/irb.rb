# frozen_string_literal: true

require_relative "csv"
require_relative "http_request"
require_relative "one_off_job"
require_relative "report"

module ConsoleBuddy
  module IRB
    include ConsoleBuddy::CSV
    include ConsoleBuddy::HttpRequest
    include ConsoleBuddy::Report

    def buddy
      ::ConsoleBuddy::Base.new
    end
    alias console_buddy buddy
  end
end
