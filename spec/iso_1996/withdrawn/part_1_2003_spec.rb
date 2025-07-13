# frozen_string_literal: true

require 'spec_helper'
require 'iso_1996/withdrawn/part_1_2003'

RSpec.describe ISO_1996::Withdrawn::Part_1_2003 do
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

  describe ".sound_exposure_level" do
    it "calculates for 1-second event" do
      p_a = 0.2 # Pa
      expected = 10 * Math.log10((1/1.0) * (p_a**2) / (20e-6)**2)
      expect(described_class.sound_exposure_level(p_a)).to be_within(0.001).of(expected)
    end
  end
end
