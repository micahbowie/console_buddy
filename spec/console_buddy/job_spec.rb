require 'spec_helper'
require 'sidekiq'
require 'active_job'
require 'resque'

require_relative '../../lib/console_buddy/job'
require_relative '../../lib/console_buddy/jobs/resque'
require_relative '../../lib/console_buddy/jobs/sidekiq'
require_relative '../../lib/console_buddy/jobs/active_job'

RSpec.describe ConsoleBuddy::Job do
  let(:args) { ['foo', 'bar'] }

  describe '#perform' do
    subject { described_class.new }

    context 'when service_type is :resque' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:resque) }

      it 'delegates to ConsoleBuddy::Jobs::Resque.perform' do
        expect(ConsoleBuddy::Jobs::Resque).to receive(:perform).with(*args)
        subject.perform(*args)
      end
    end

    context 'when service_type is :sidekiq' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:sidekiq) }

      it 'delegates to ConsoleBuddy::Jobs::Sidekiq.new.perform' do
        sidekiq_instance = instance_double(ConsoleBuddy::Jobs::Sidekiq)
        allow(ConsoleBuddy::Jobs::Sidekiq).to receive(:new).and_return(sidekiq_instance)
        expect(sidekiq_instance).to receive(:perform).with(*args)
        subject.perform(*args)
      end
    end

    context 'when service_type is :active_job' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:active_job) }

      it 'delegates to ConsoleBuddy::Jobs::ActiveJob.perform' do
        expect(ConsoleBuddy::Jobs::ActiveJob).to receive(:perform).with(*args)
        subject.perform(*args)
      end
    end

    context 'when service_type is unknown' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:unknown) }

      it 'delegates to ConsoleBuddy::OneOffJob.perform' do
        expect(ConsoleBuddy::OneOffJob).to receive(:perform).with(*args)
        subject.perform(*args)
      end
    end
  end

  describe '.perform_async' do
    context 'when service_type is :resque' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:resque) }

      it 'delegates to ConsoleBuddy::Jobs::Resque.perform_later' do
        expect(ConsoleBuddy::Jobs::Resque).to receive(:perform_later).with(*args)
        described_class.perform_async(*args)
      end
    end

    context 'when service_type is :sidekiq' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:sidekiq) }

      it 'delegates to ConsoleBuddy::Jobs::Sidekiq.perform_async' do
        expect(ConsoleBuddy::Jobs::Sidekiq).to receive(:perform_async).with(*args)
        described_class.perform_async(*args)
      end
    end

    context 'when service_type is :active_job' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:active_job) }

      it 'delegates to ConsoleBuddy::Jobs::ActiveJob.perform_later' do
        expect(ConsoleBuddy::Jobs::ActiveJob).to receive(:perform_later).with(*args)
        described_class.perform_async(*args)
      end
    end

    context 'when service_type is unknown' do
      before { allow(ConsoleBuddy::OneOffJob).to receive(:service_type).and_return(:unknown) }

      it 'delegates to ConsoleBuddy::OneOffJob.perform' do
        expect(ConsoleBuddy::OneOffJob).to receive(:perform).with(*args)
        described_class.perform_async(*args)
      end
    end
  end

  describe '.perform_later' do
    it 'delegates to .perform_async' do
      expect(described_class).to receive(:perform_async).with(*args)
      described_class.perform_later(*args)
    end
  end
end