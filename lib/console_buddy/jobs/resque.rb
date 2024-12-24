# frozen_string_literal: true

require_relative "../one_off_job"

# Example Usage: ConsoleBuddy::Jobs::Resque.perform_later("foo", "bar")
# 
# This class is used to integrate the ConsoleBuddy::OneOffJob with Resque.
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
