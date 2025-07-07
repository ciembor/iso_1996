# spec/iso_1996_1_2003/definitions_spec.rb

# frozen_string_literal: true

require 'iso_1996_1_2003/definitions'

RSpec.describe ISO_1996_1_2003 do
  describe ISO_1996_1_2003::WeightingType do
    it 'includes valid keys' do
      expect(described_class::ALL.map(&:key)).to contain_exactly(:A, :C, :Z)
    end

    it 'compares correctly' do
      expect(described_class::A).to eq(described_class::A)
      expect(described_class::A).not_to eq(described_class::C)
    end
  end

  describe ISO_1996_1_2003::LevelMetric do
    it 'includes known level metrics' do
      keys = described_class::ALL.map(&:key)
      expect(keys).to include(:LAeq, :LAE, :LAmax, :LCpeak, :LR, :Lden, :Lnight)
    end
  end

  describe ISO_1996_1_2003::AcousticDescriptor do
    let(:desc) { described_class.new(metric: ISO_1996_1_2003::LevelMetric::LAeq, weighting: ISO_1996_1_2003::WeightingType::A, description: 'Test') }

    it 'initializes and formats correctly' do
      expect(desc.to_s).to eq('LAeq(A) – Test')
    end
  end

  describe ISO_1996_1_2003::PeriodOfDay do
    it 'includes proper penalties and hours' do
      expect(described_class::DAY.penalty_db).to eq(0)
      expect(described_class::EVENING.penalty_db).to eq(5)
      expect(described_class::NIGHT.penalty_db).to eq(10)
    end
  end

  describe ISO_1996_1_2003::AdjustmentType do
    it 'contains all adjustment types' do
      expect(described_class::ALL.map(&:key)).to include(:impulsiveness, :tonality, :low_frequency, :other)
    end
  end

  describe ISO_1996_1_2003::SoundEventType do
    it 'contains all event types' do
      expect(described_class::ALL.map(&:key)).to include(:single_event, :repetitive_event, :continuous, :impulsive)
    end
  end

  describe 'DESCRIPTORS' do
    it 'contains valid descriptor objects' do
      expect(ISO_1996_1_2003::DESCRIPTORS).to all(be_a(ISO_1996_1_2003::AcousticDescriptor))
    end
  end
end
