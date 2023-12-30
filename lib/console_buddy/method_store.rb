# frozen_string_literal: true

module ConsoleBuddy
  class MethodStore
    attr_accessor :active_record_helper_methods, :console_method

    def initialize
      @active_record_helper_methods = ::Hash.new { |hash, key| hash[key] = [] }
      @console_method = ::Hash.new
    end
  end
end
