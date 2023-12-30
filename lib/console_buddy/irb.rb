# frozen_string_literal: true

require_relative "csv"

module ConsoleBuddy
  module IRB
    include ConsoleBuddy::CSV

    def buddy
      ::ConsoleBuddy::Base.new
    end
    alias console_buddy buddy
  end
end
