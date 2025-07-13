# frozen_string_literal: true

require 'spec_helper'
require 'iso_1996/withdrawn/part_3_1987'

RSpec.describe ISO_1996::Withdrawn::Part_3_1987 do
  describe ".tonal_adjustment_factor" do
    it "returns 6 dB for ΔL >= 15 dB (ISO 1996-3:1987 Table 1)" do
      expect(described_class.tonal_adjustment_factor(15)).to eq(6.0)
      expect(described_class.tonal_adjustment_factor(20)).to eq(6.0)
    end

    it "returns 5 dB for ΔL = 12 dB (ISO 1996-3:1987 Table 1)" do
      expect(described_class.tonal_adjustment_factor(12)).to eq(5.0)
    end

    it "returns 2 dB for ΔL = 7 dB (ISO 1996-3:1987 Table 1)" do
      expect(described_class.tonal_adjustment_factor(7)).to eq(2.0)
    end

    it "returns 0 dB for ΔL < 5 dB (ISO 1996-3:1987 Table 1)" do
      expect(described_class.tonal_adjustment_factor(4.9)).to eq(0.0)
    end
  end

  describe ".impulsive_adjustment_factor" do
    it "returns 6 dB for L_Cpeak >= 130 dB" do
      expect(described_class.impulsive_adjustment_factor(130.0)).to eq(6.0)
      expect(described_class.impulsive_adjustment_factor(135.0)).to eq(6.0)
    end

    it "returns 6 dB for subjectively annoying noise" do
      expect(described_class.impulsive_adjustment_factor(125.0, is_highly_annoying: true)).to eq(6.0)
    end

    it "returns 0 dB for non-impulsive noise" do
      expect(described_class.impulsive_adjustment_factor(125.0)).to eq(0.0)
    end
  end

  describe ".assessment_level" do
    it "calculates according to ISO 1996-3:1987 Section 8" do
      expect(described_class.assessment_level(57.8, 3.0, 2.0)).to eq(62.8)
    end
  end

  describe ".compliance_evaluation" do
    it "returns true when limit is exceeded" do
      # 65.0 > (62.0 + 2.0) = 64.0
      expect(described_class.compliance_evaluation(65.0, 62.0, 2.0)).to be true
    end

    it "returns false when within limits" do
      # 63.9 <= (62.0 + 2.0) = 64.0
      expect(described_class.compliance_evaluation(63.9, 62.0, 2.0)).to be false
    end
  end

  describe ".time_period_conversion" do
    it "calculates equivalent level for day/night (ISO 1996-3:1987 Annex A)" do
      periods = [
        {level: 65.0, duration: 16}, # Day
        {level: 55.0, duration: 8}   # Night
      ]
      
      # Manual calculation:
      energy_day = 16 * 10**(65.0/10)
      energy_night = 8 * 10**(55.0/10)
      total_energy = energy_day + energy_night
      expected = 10 * Math.log10(total_energy / 24.0)
      
      expect(described_class.time_period_conversion(periods)).to be_within(0.001).of(expected)
    end

    it "handles multiple periods" do
      periods = [
        {level: 60.0, duration: 8},
        {level: 65.0, duration: 8},
        {level: 70.0, duration: 8}
      ]
      
      total_energy = 0
      periods.each do |p|
        total_energy += p[:duration] * 10**(p[:level]/10.0)
      end
      expected = 10 * Math.log10(total_energy / 24.0)
      
      expect(described_class.time_period_conversion(periods)).to be_within(0.001).of(expected)
    end
  end
end
