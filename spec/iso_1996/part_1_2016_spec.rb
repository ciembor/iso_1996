# frozen_string_literal: true

require 'spec_helper'
require 'iso_1996/part_1_2016'

RSpec.describe ISO_1996::Part_1_2016 do
  describe ".sound_pressure_level" do
    it "calculates sound pressure level for reference pressure" do
      p = 20e-6 # Pa (reference pressure)
      expect(described_class.sound_pressure_level(p)).to be_within(0.0001).of(0.0)
    end

    it "calculates sound pressure level for typical environmental noise" do
      # Typical street noise: 0.063 Pa (70 dB)
      p = 0.063
      expected = 10 * Math.log10((p**2) / (20e-6)**2)
      expect(described_class.sound_pressure_level(p)).to be_within(0.001).of(expected)
    end

    it "calculates sound pressure level for loud noise" do
      # Jackhammer at 1m: 2.0 Pa (120 dB)
      p = 2.0
      expected = 20 * Math.log10(p / 20e-6)
      expect(described_class.sound_pressure_level(p)).to be_within(0.001).of(expected)
    end
  end

  describe ".sound_exposure_level" do
    it "calculates for 1-second event" do
      p_a = 0.2 # Pa
      expected = 10 * Math.log10((1/1.0) * (p_a**2) / (20e-6)**2)
      expect(described_class.sound_exposure_level(p_a)).to be_within(0.001).of(expected)
    end

    it "handles zero pressure" do
      expect(described_class.sound_exposure_level(0)).to eq(-Float::INFINITY)
    end
  end

  describe ".equivalent_continuous_sound_level" do
    it "calculates for constant sound" do
      levels = [65.0] * 3600
      expected = 65.0
      expect(described_class.equivalent_continuous_sound_level(levels, 3600)).to be_within(0.001).of(expected)
    end

    it "calculates for varying sound levels" do
      levels = [55.0, 65.0, 75.0] # 3 seconds of measurements
      energy_sum = 10**(5.5) + 10**(6.5) + 10**(7.5)
      expected = 10 * Math.log10(energy_sum / 3.0)
      expect(described_class.equivalent_continuous_sound_level(levels, 3.0)).to be_within(0.001).of(expected)
    end

    it "raises error for zero measurement time" do
      expect {
        described_class.equivalent_continuous_sound_level([65.0], 0)
      }.to raise_error(ArgumentError, "Measurement time must be positive")
    end
  
    it "raises error for negative measurement time" do
      expect {
        described_class.equivalent_continuous_sound_level([65.0], -10)
      }.to raise_error(ArgumentError, "Measurement time must be positive")
    end
  
    it "returns -Infinity for empty measurement period" do
      expect(described_class.equivalent_continuous_sound_level([], 1)).to eq(-Float::INFINITY)
    end
  end

  describe ".peak_sound_pressure_level" do
    it "calculates for reference pressure" do
      expect(described_class.peak_sound_pressure_level(20e-6)).to be_within(0.001).of(0.0)
    end

    it "calculates for gunshot peak" do
      # Gunshot peak: 200 Pa (140 dB)
      p_c_max = 200.0
      expected = 20 * Math.log10(p_c_max / 20e-6)
      expect(described_class.peak_sound_pressure_level(p_c_max)).to be_within(0.001).of(expected)
    end
  end

  describe ".day_evening_night_level" do
    it "calculates L_den with standard parameters" do
      l_day = 65.0
      l_evening = 60.0
      l_night = 55.0
      
      # Manual calculation
      term_day = 12 * 10**(6.5)
      term_evening = 4 * 10**((60 + 5) / 10.0)
      term_night = 8 * 10**((55 + 10) / 10.0)
      expected = 10 * Math.log10((term_day + term_evening + term_night) / 24.0)
      
      expect(described_class.day_evening_night_level(l_day, l_evening, l_night))
        .to be_within(0.001).of(expected)
    end

    it "calculates with custom parameters" do
      l_day = 70.0
      l_evening = 65.0
      l_night = 60.0
      
      result = described_class.day_evening_night_level(
        l_day, l_evening, l_night,
        day_duration: 10,
        evening_duration: 6,
        night_duration: 8,
        evening_penalty: 3,
        night_penalty: 7
      )
      
      term_day = 10 * 10**(7.0)
      term_evening = 6 * 10**((65 + 3) / 10.0)
      term_night = 8 * 10**((60 + 7) / 10.0)
      expected = 10 * Math.log10((term_day + term_evening + term_night) / 24.0)
      
      expect(result).to be_within(0.001).of(expected)
    end
  end

  describe ".tonal_adjustment_factor" do
    it "returns 6 dB for prominent tones" do
      expect(described_class.tonal_adjustment_factor(is_audible: true, is_prominent: true)).to eq(6.0)
    end

    it "returns 3 dB for audible but not prominent tones" do
      expect(described_class.tonal_adjustment_factor(is_audible: true, is_prominent: false)).to eq(3.0)
    end

    it "returns 0 dB for inaudible tones" do
      expect(described_class.tonal_adjustment_factor(is_audible: false)).to eq(0.0)
      expect(described_class.tonal_adjustment_factor(is_audible: false, is_prominent: true)).to eq(0.0)
      expect(described_class.tonal_adjustment_factor(is_audible: false, is_prominent: false)).to eq(0.0)
    end
  end

  describe ".impulsive_adjustment_factor" do
    it "returns 6 dB for distinct impulses" do
      expect(described_class.impulsive_adjustment_factor(is_audible: true, is_distinct: true)).to eq(6.0)
    end

    it "returns 3 dB for audible but not distinct impulses" do
      expect(described_class.impulsive_adjustment_factor(is_audible: true, is_distinct: false)).to eq(3.0)
    end

    it "returns 0 dB for inaudible impulses" do
      expect(described_class.impulsive_adjustment_factor(is_audible: false)).to eq(0.0)
      expect(described_class.impulsive_adjustment_factor(is_audible: false, is_distinct: true)).to eq(0.0)
      expect(described_class.impulsive_adjustment_factor(is_audible: false, is_distinct: false)).to eq(0.0)
    end
  end

  describe ".compliance_evaluation" do
    it "passes when below limit with uncertainty" do
      expect(described_class.compliance_evaluation(62.0, 65.0, 1.5)).to be false
    end

    it "fails when above limit with uncertainty" do
      expect(described_class.compliance_evaluation(67.0, 65.0, 1.5)).to be true
    end

    it "passes when equal to limit plus uncertainty" do
      expect(described_class.compliance_evaluation(66.5, 65.0, 1.5)).to be false
    end

    it "passes when below limit plus uncertainty" do
      expect(described_class.compliance_evaluation(66.4, 65.0, 1.5)).to be false
    end
  end

  describe ".assessment_level" do
    it "calculates without adjustments" do
      expect(described_class.assessment_level(65.0, 0, 0)).to eq(65.0)
    end

    it "applies both adjustments" do
      expect(described_class.assessment_level(60.0, 3.0, 6.0)).to eq(69.0)
    end

    it "handles negative adjustments" do
      expect(described_class.assessment_level(70.0, -2.0, -1.5)).to eq(66.5)
    end
  end
end
