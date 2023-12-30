# frozen_string_literal: true

require 'rails/railtie'

module ConsoleBuddy
  class Railtie < ::Rails::Railtie
    console do
      ::ConsoleBuddy.start!
    end
  end
end

require "console_buddy/railtie" if defined?(::Rails::Railtie)