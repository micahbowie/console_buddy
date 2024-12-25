require 'spec_helper'
require 'webmock/rspec'
require 'httparty'
require_relative '../../lib/console_buddy/http_request'

RSpec.describe ConsoleBuddy::HttpRequest do
  include ConsoleBuddy::HttpRequest

  describe '#ping' do
    let(:url) { 'http://example.com' }
    let(:response_body) { { 'message' => 'Hello, world!' }.to_json }

    before do
      stub_request(:get, url).to_return(body: response_body, headers: { 'Content-Type' => 'application/json' })
    end

    it 'makes an HTTP GET request to the given URL' do
      expect(HTTParty).to receive(:get).with(url).and_call_original
      ping(url)
    end

    it 'parses the JSON response' do
      result = ping(url)
      expect(result).to eq('message' => 'Hello, world!')
    end
  end
end