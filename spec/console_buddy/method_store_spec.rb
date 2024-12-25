require 'spec_helper'
require_relative '../../lib/console_buddy/method_store'

RSpec.describe ConsoleBuddy::MethodStore do
  describe '#initialize' do
    it 'initializes augment_helper_methods as a hash with default array values' do
      method_store = ConsoleBuddy::MethodStore.new
      expect(method_store.augment_helper_methods).to be_a(Hash)
      expect(method_store.augment_helper_methods.default_proc).not_to be_nil
      expect(method_store.augment_helper_methods[:some_key]).to eq([])
    end

    it 'initializes console_method as an empty hash' do
      method_store = ConsoleBuddy::MethodStore.new
      expect(method_store.console_method).to be_a(Hash)
      expect(method_store.console_method).to be_empty
    end
  end

  describe 'attributes' do
    let(:method_store) { ConsoleBuddy::MethodStore.new }

    it 'allows reading and writing for :augment_helper_methods' do
      method_store.augment_helper_methods[:test] = ['method1']
      expect(method_store.augment_helper_methods[:test]).to eq(['method1'])
    end

    it 'allows reading and writing for :console_method' do
      method_store.console_method[:test_method] = 'some_method'
      expect(method_store.console_method[:test_method]).to eq('some_method')
    end
  end
end