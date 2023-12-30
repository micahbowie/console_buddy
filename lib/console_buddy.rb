# frozen_string_literal: true

require 'active_support'
require 'active_support/all'

require_relative "console_buddy/method_store"
require_relative "console_buddy/active_record_helpers"
require_relative "console_buddy/base"
require_relative "console_buddy/helpers"
require_relative "console_buddy/irb"
require_relative "console_buddy/railtie"
require_relative "console_buddy/version"

module ConsoleBuddy
  class << self
    def store
      @store ||= ::ConsoleBuddy::MethodStore.new
    end

    def start!
      begin
        ::ConsoleBuddy.store.active_record_helper_methods.each do |klass, methods|
          methods.each do |method|
            klass.constantize.define_method(method[:method_name]) do |*args|
              instance_exec(*args, &method[:block])
            end
          end
        end

        ::ConsoleBuddy.store.console_method.each do |method_name, block|
          ::ConsoleBuddy::IRB.define_method(method_name, block)
        end

        augment_irb
        augment_rails
        return "ConsoleBuddy session started!"
      rescue ::StandardError => error
        puts "ConsoleBuddy encountered an error: #{error.message} during startup."
      end
    end

    private

    def augment_irb
      if defined? IRB::ExtendCommandBundle
        IRB::ExtendCommandBundle.include(ConsoleBuddy::IRB)
      end
    end

    def augment_rails
      if defined? Rails
        require_relative "console_buddy/railtie"
      end
    end
  end
end
