# frozen_string_literal: true

require_relative "../one_off_job"

module ConsoleBuddy
  module Jobs
    class ActiveJob < ::ActiveJob::Base
      def perform(*args)
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end
  end
end
