require 'byebug'
require 'byebug/command'

require_relative '../irb'

module ConsoleBuddy
  module Byebug
    class BuddyCommand < ::Byebug::Command
      include ::ConsoleBuddy::IRB
      #
      # Return a regex to match the "buddy" command input.
      #
      # Example: buddy.ping "http://example.com"
      def self.regexp
        /^\s*buddy(?:\.(\w+))?\s*(.*)$/
      end

      def self.buddy
        ::ConsoleBuddy::Base.new
      end

      #
      # Execute the command.
      #
      def execute
        method_name = @match[1]
        args = @match[2]

        if method_name
          result = self.class.buddy.send(method_name, *parse_args(args))
          puts result
        else
          puts "Buddy command executed"
        end
      end

      #
      # Short description shown in the 'help' output.
      #
      def short_description
        "Executes buddy commands"
      end

      #
      # Long description shown in the 'help <command>' output.
      #
      def long_description
        "Executes buddy commands with optional method calls, e.g., buddy.ping"
      end


      private

      def parse_args(args)
        eval(args)
      rescue SyntaxError, NameError => e
        puts "Error parsing arguments: #{e.message}"
        []
      end
    end
  end
end
