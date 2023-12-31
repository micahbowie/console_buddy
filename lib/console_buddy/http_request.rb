# frozen_string_literal: true

require 'httparty'

module ConsoleBuddy
  module HttpRequest
    def ping(url)
      response = ::HTTParty.get(url)
      ::JSON.parse(response.body)
    end
  end
end
