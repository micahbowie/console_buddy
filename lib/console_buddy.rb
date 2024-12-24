# frozen_string_literal: true

require 'active_support'
require 'active_support/all'

require_relative "console_buddy/method_store"
require_relative "console_buddy/augment"
require_relative "console_buddy/base"
require_relative "console_buddy/helpers"
require_relative "console_buddy/irb"
require_relative "console_buddy/version"



require_relative "console_buddy/one_off_job"
require_relative "console_buddy/job"
require_relative "console_buddy/jobs/sidekiq"
require_relative "console_buddy/jobs/resque"
require_relative "console_buddy/jobs/active_job"

module ConsoleBuddy
  class << self
    def store
      @store ||= ::ConsoleBuddy::MethodStore.new
    end

    def start!
      begin
        augment_classes
        augment_console
        start_buddy_in_irb
        start_buddy_in_rails
        puts "ConsoleBuddy session started!"
      rescue ::StandardError => error
        puts "ConsoleBuddy encountered an during startup. [Error]: #{error.message}"
      end
    end

    private

    def augment_classes
      ::ConsoleBuddy.store.augment_helper_methods.each do |klass, methods|
        methods.each do |method|
          case method[:method_type]
          when :instance
            klass.constantize.define_method(method[:method_name]) do |*args|
              instance_exec(*args, &method[:block])
            end
          when :class
            klass.constantize.define_singleton_method(method[:method_name]) do |*args|
              instance_exec(*args, &method[:block])
            end
          else
            next
          end
        end
      end
    end

    def augment_console
      ::ConsoleBuddy.store.console_method.each do |method_name, block|
        ::ConsoleBuddy::IRB.define_method(method_name, block)
      end
    end

    def start_buddy_in_irb
      if defined? IRB::ExtendCommandBundle
        IRB::ExtendCommandBundle.include(ConsoleBuddy::IRB)
        require 'progress_bar/core_ext/enumerable_with_progress'
      end
    end

    def start_buddy_in_rails
      if defined? Rails::ConsoleMethods
        Rails::ConsoleMethods.include(ConsoleBuddy::IRB)
        require 'progress_bar/core_ext/enumerable_with_progress'
      end
    end
  end
end

if defined? Rails
  require_relative "console_buddy/railtie"
end
