# frozen_string_literal: true
# 
# Example:
# ConsoleBuddy::OneOffJob.define { puts "one offer man...another one"; puts User.last.attributes; }
# Usage: ConsoleBuddy::OneOffJob.perform
# 
# Example 2:
# 
# ConsoleBuddy::OneOffJob.define do |user_id|
#   puts User.find(user_id).attributes
# end
# 
module ConsoleBuddy
  class InvalidJobServiceType < StandardError; end

  class OneOffJob
    SERVICE_TYPES = [:sidekiq, :resque, :active_job, :inline].freeze
    class << self
      def service_type
        return @service_type if defined?(@service_type)
        return ConsoleBuddy.one_off_job_service_type if ConsoleBuddy.one_off_job_service_type.present?

        :inline
      end

      def service_type=(type)
        raise InvalidJobServiceType, "Valid service types are #{SERVICE_TYPES.join(', ')}" unless SERVICE_TYPES.include?(type)
        @service_type = type
      end

      def define(&block)
        @block = block
      end

      def perform(*args)
        return unless @block

        @block.call(*args)
      end
    end
  end
end
