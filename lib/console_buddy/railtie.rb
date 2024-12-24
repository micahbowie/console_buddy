# frozen_string_literal: true

require 'rails/railtie'

# Load console buddy when the Rails console is started
module ConsoleBuddy
  class Railtie < ::Rails::Railtie
    console do
      ::ConsoleBuddy.start!
    end
  end
end

require "console_buddy/railtie" if defined?(::Rails::Railtie)