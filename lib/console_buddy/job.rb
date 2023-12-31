# frozen_string_literal: true

require_relative 'one_off_job'

module ConsoleBuddy
  class Job
    def perform(*args)
      job_type = ::ConsoleBuddy::OneOffJob.service_type

      case job_type
      when :resque
        require_relative "console_buddy/resque_job"
        ::ConsoleBuddy::Jobs::Resque.perform(*args)
      when :sidekiq
        require_relative "console_buddy/sidekiq_job"
        ::ConsoleBuddy::Jobs::Sidekiq.perform(*args)
      when :active_job
        require_relative "console_buddy/active_job"
        ::ConsoleBuddy::Jobs::ActiveJob.perform(*args)
      else
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end
  end
end