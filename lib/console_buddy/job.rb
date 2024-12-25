# frozen_string_literal: true

require_relative 'one_off_job'

# This class is used to integrate the ConsoleBuddy::OneOffJob with Resque, Sidekiq, and ActiveJob.
# You can define your job and then run it using the `perform` method of this class.
# That will then delegate this performance to the correct "job" class based on the service type.
# 
# Example Usage: ConsoleBuddy::Job.perform("foo", "bar")
module ConsoleBuddy
  class Job
    def perform(*args)
      job_type = ::ConsoleBuddy::OneOffJob.service_type

      case job_type
      when :resque
        require_relative "jobs/resque"
        ::ConsoleBuddy::Jobs::Resque.perform(*args)
      when :sidekiq
        require_relative "jobs/sidekiq"
        ::ConsoleBuddy::Jobs::Sidekiq.new.perform(*args)
      when :active_job
        require_relative "jobs/active_job"
        ::ConsoleBuddy::Jobs::ActiveJob.perform(*args)
      else
        ::ConsoleBuddy::OneOffJob.perform(*args)
      end
    end

    class << self
      def perform_async(*args)
        job_type = ::ConsoleBuddy::OneOffJob.service_type

        case job_type
        when :resque
          require_relative "jobs/resque"
          ::ConsoleBuddy::Jobs::Resque.perform_later(*args)
        when :sidekiq
          require_relative "jobs/sidekiq"
          ::ConsoleBuddy::Jobs::Sidekiq.perform_async(*args)
        when :active_job
          require_relative "jobs/active_job"
          ::ConsoleBuddy::Jobs::ActiveJob.perform_later(*args)
        else
          ::ConsoleBuddy::OneOffJob.perform(*args)
        end
      end

      def perform_later(*args)
        self.perform_async(*args)
      end
    end
  end
end