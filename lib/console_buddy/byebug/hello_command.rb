require 'byebug'
require 'byebug/command'

module ConsoleBuddy
  module Byebug
    #
    # A demo "hey_buddy" command for Byebug.
    #
    class HelloCommand < ::Byebug::Command
      #
      # Return a regex to match the "hey_buddy" command input.
      #
      def self.regexp
        /^\s*hey_buddy\s*$/
      end

      #
      # Short description shown in the 'help' output.
      #
      def self.description
        <<-EOD
          hello: Prints "Hi, I'm buddy!"
        EOD
      end

      #
      # Called when the user types `hey_buddy` in Byebug.
      #
      def execute
        puts "Hi, I'm buddy!"
      end
    end
  end
end
