# frozen_string_literal: true

require_relative "../one_off_job"

module ConsoleBuddy
  class NotImplementedError < ::StandardError; end

  module Jobs
    class Sidekiq
      if defined? ::Sidekiq::Job
        include ::Sidekiq::Job
      else
        raise ::ConsoleBuddy::NotImplementedError, "Sidekiq is not configured correctyl or it is not correctly loaded."
      end

      def perform(*args)
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end
  end
end
