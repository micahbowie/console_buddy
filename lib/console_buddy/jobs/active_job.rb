# frozen_string_literal: true

require_relative "../one_off_job"

# Example Usage: ConsoleBuddy::Jobs::ActiveJob.perform_later("foo", "bar")
# 
# This class is used to integrate the ConsoleBuddy::OneOffJob with ActiveJob.
module ConsoleBuddy
  module Jobs
    class ActiveJob < ::ActiveJob::Base
      def perform(*args)
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end
  end
end
