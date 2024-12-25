require 'spec_helper'
require_relative '../../lib/console_buddy/augment'
require_relative '../../lib/console_buddy/method_store'

RSpec.describe ConsoleBuddy::Augment do
  describe '.define' do
    it 'executes the given block in the context of ConsoleBuddy::Augment::DSL' do
      dsl_instance = instance_double(ConsoleBuddy::Augment::DSL)
      allow(ConsoleBuddy::Augment::DSL).to receive(:new).and_return(dsl_instance)
      expect(dsl_instance).to receive(:instance_eval)

      described_class.define {}
    end

    it 'does nothing if no block is given' do
      expect { described_class.define }.not_to raise_error
    end
  end

  describe ConsoleBuddy::Augment::DSL do
    let(:klass) { Class.new }
    let(:method_name) { :test_method }
    let(:new_method_name) { :new_test_method }
    let(:block) { proc { 'test' } }
    let(:store) { ConsoleBuddy::MethodStore.new }
    
    before do
      allow(ConsoleBuddy).to receive(:store).and_return(store)
    end

    describe '#method' do
      it 'stores the method definition in the augment_helper_methods store' do
        subject.method(klass, method_name, &block)
        expect(store.augment_helper_methods[klass.to_s]).to include(
          method_name: method_name,
          block: block,
          method_type: :instance
        )
      end

      it 'raises an error for invalid method type' do
        expect {
          subject.method(klass, method_name, type: :invalid, &block)
        }.to raise_error(ConsoleBuddy::Augment::DSL::InvalidTypeError, "Invalid method type. Must be either :instance or :class")
      end
    end

    describe '#method_alias' do
      it 'stores the method alias definition in the augment_helper_methods store' do
        subject.method_alias(klass, method_name, new_method_name)
        expect(store.augment_helper_methods[klass.to_s]).to include(
          method_name: new_method_name,
          block: an_instance_of(Proc),
          method_type: :instance
        )
      end

      it 'raises an error for invalid method type' do
        expect {
          subject.method_alias(klass, method_name, new_method_name, type: :invalid)
        }.to raise_error(ConsoleBuddy::Augment::DSL::InvalidTypeError, "Invalid method type. Must be either :instance or :class")
      end
    end
  end
end