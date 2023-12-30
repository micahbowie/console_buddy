# frozen_string_literal: true

require_relative "irb"

module ConsoleBuddy
  class Base
    include ::ConsoleBuddy::IRB
  end
end