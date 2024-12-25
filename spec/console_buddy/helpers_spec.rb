require 'spec_helper'
require_relative '../../lib/console_buddy/helpers'
require_relative '../../lib/console_buddy/method_store'

RSpec.describe ConsoleBuddy::Helpers do
  describe '.define' do
    it 'executes the given block in the context of ConsoleBuddy::Helpers::DSL' do
      dsl_instance = instance_double(ConsoleBuddy::Helpers::DSL)
      allow(ConsoleBuddy::Helpers::DSL).to receive(:new).and_return(dsl_instance)
      expect(dsl_instance).to receive(:instance_eval)

      described_class.define {}
    end

    it 'does nothing if no block is given' do
      expect { described_class.define }.not_to raise_error
    end
  end

  describe ConsoleBuddy::Helpers::DSL do
    let(:method_name) { :call_api }
    let(:block) { proc { |status, message| puts "RESPONSE: { #{status}, #{message} }" } }
    let(:store) { ConsoleBuddy::MethodStore.new }

    before do
      allow(ConsoleBuddy).to receive(:store).and_return(store)
    end

    describe '#console_method' do
      it 'stores the method definition in the console_method store' do
        subject.console_method(method_name, &block)
        expect(store.console_method[method_name]).to eq(block)
      end
    end
  end
end