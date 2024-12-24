# frozen_string_literal: true

require 'pathname'
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

# Only load the one-off job classes if the gems are installed
begin
  require 'sidekiq'
  require_relative "console_buddy/jobs/sidekiq"
rescue LoadError
  # puts "Sidekiq gem not installed, skipping sidekiq job integration."
end

begin
  require 'resque'
  require_relative "console_buddy/jobs/resque"
rescue LoadError
  # puts "Resque gem not installed, skipping resque job integration."
end

begin
  require 'activejob'
  require_relative "console_buddy/jobs/active_job"
rescue LoadError
  # puts "ActiveJob gem not installed, skipping active job integration."
end

module ConsoleBuddy
  class << self
    attr_accessor :verbose_console, :allowed_envs, :use_in_debuggers, :ignore_startup_errors, :use_in_tests, :one_off_job_service_type

    def store
      @store ||= ::ConsoleBuddy::MethodStore.new
    end

    def start!
      set_config_defaults
      load_console_buddy_config
      return if !allowed_env?
      return if test? && !use_in_tests

      begin
        load_console_buddy_files
        augment_classes
        augment_console
        start_buddy_in_irb
        start_buddy_in_rails
        start_buddy_in_byebug
        puts "ConsoleBuddy session started! Debugger: #{use_in_debuggers} | Test: #{current_env}" if verbose_console
      rescue ::StandardError => error
        puts "ConsoleBuddy encountered an during startup. [Error]: #{error.message}" if ignore_startup_errors
      end
    end

    def load_byebug!
      start_buddy_in_byebug
    end

    private

    def set_config_defaults
      @verbose_console = true
      @use_in_tests = false
      @use_in_debuggers = false
      @ignore_startup_errors = false
      @allowed_envs = %w[development test]
      @one_off_job_service_type = :inline
    end

    # Only start the buddy in the allowed environments
    def allowed_env?
      if current_env.present?
        can_start = allowed_envs.include?(current_env)
        if verbose_console && can_start
          puts "ConsoleBuddy is starting in #{current_env} environment."
        end
        return can_start
      end

      true
    end

    def test?
      current_env == 'test'
    end

    def current_env
      ENV['RAILS_ENV'] == 'test' || ENV['RACK_ENV']
    end

    # Loads the .console_buddy/config file if present
    def load_console_buddy_config
      config_path = Pathname.new(File.join(Dir.pwd, '.console_buddy', 'config.rb'))
      if config_path.exist? && config_path.file?
        require config_path.to_s
      else
        puts ".console_buddy/config file not found."
      end
    end

    # Loads all the files in the .console_buddy folder
    # .console_buddy folder should be in the root of the project
    def load_console_buddy_files
      console_buddy_path = Pathname.new(File.join(Dir.pwd, '.console_buddy'))
      if console_buddy_path.exist? && console_buddy_path.directory?
        console_buddy_path.each_child do |file|
          next unless file.file?
          require file.to_s
        end
      else
        puts ".console_buddy folder not found in the root of the project."
      end
    end

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

    def start_buddy_in_byebug
      return if !use_in_debuggers

      if defined?(Byebug)
        byebug_path = Pathname.new(File.join(__dir__, 'console_buddy', 'byebug'))

        if byebug_path.exist? && byebug_path.directory?
          byebug_path.each_child do |file|
            next unless file.file?
            require file.to_s
          end
        end

        [
          ConsoleBuddy::Byebug::HelloCommand,
          ConsoleBuddy::Byebug::BuddyCommand,
        ].each do |command_class|
          ::Byebug.const_set(
            command_class.name.split('::').last,
            command_class,
          )
        end
      end
    end
  end
end

require_relative "console_buddy/initializers/byebug"
require_relative "console_buddy/initializers/rails"
require_relative "console_buddy/initializers/rspec"