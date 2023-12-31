# frozen_string_literal: true

require_relative "../one_off_job"

module ConsoleBuddy
  module Jobs
    class Resque
      @queue = :console_buddy

      def perform(*args)
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end
  end
end
