# frozen_string_literal: true

require 'spec_helper'
require 'iso_1996/environmental_noise'

RSpec.describe ISO_1996::EnvironmentalNoise do
  describe ".background_noise_correction" do
    it "returns 0 for ΔL >= 10 dB" do
      expect(described_class.background_noise_correction(70, 60)).to eq(0.0)
      expect(described_class.background_noise_correction(65.5, 55.0)).to eq(0.0)
    end

    it "calculates correction for ΔL = 6 dB (ISO 1996-2:2007 Table D.1)" do
      # Expected value: 1.3 dB
      delta_l = 6.0
      expected = -10 * Math.log10(1 - 10**(-0.1 * delta_l))
      expect(described_class.background_noise_correction(66, 60)).to be_within(0.001).of(expected)
    end

    it "calculates correction for ΔL = 4 dB (ISO 1996-2:2007 Table D.1)" do
      # Expected value: 2.2 dB
      delta_l = 4.0
      expected = -10 * Math.log10(1 - 10**(-0.1 * delta_l))
      expect(described_class.background_noise_correction(64, 60)).to be_within(0.001).of(expected)
    end

    it "raises error for ΔL <= 3 dB" do
      expect { described_class.background_noise_correction(63.0, 61.0) }.to raise_error(ArgumentError)
      expect { described_class.background_noise_correction(62.5, 62.5) }.to raise_error(ArgumentError)
    end
  end

  describe ".measurement_uncertainty" do
    it "calculates for multiple components" do
      uncertainties = [1.2, 0.8, 0.5]
      expected = Math.sqrt(1.2**2 + 0.8**2 + 0.5**2)
      expect(described_class.measurement_uncertainty(uncertainties)).to be_within(0.001).of(expected)
    end

    it "returns 0 for no components" do
      expect(described_class.measurement_uncertainty([])).to eq(0.0)
    end
  end

  describe ".atmospheric_absorption_correction" do
    it "calculates for typical conditions" do
      # For 100m at 0.01 dB/m attenuation
      expect(described_class.atmospheric_absorption_correction(0.01, 100)).to eq(1.0)
    end
  end
end
