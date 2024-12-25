require 'spec_helper'
require_relative '../../lib/console_buddy/irb'
require_relative '../../lib/console_buddy/base'

RSpec.describe ConsoleBuddy::IRB do
  include ConsoleBuddy::IRB

  describe '#buddy' do
    it 'returns a new instance of ConsoleBuddy::Base' do
      expect(buddy).to be_an_instance_of(ConsoleBuddy::Base)
    end
  end

  describe '#console_buddy' do
    it 'is an alias for #buddy' do
      expect(console_buddy).to be_an_instance_of(ConsoleBuddy::Base)
    end
  end
end