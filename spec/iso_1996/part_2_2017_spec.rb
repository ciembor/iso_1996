# frozen_string_literal: true

require 'spec_helper'
require 'iso_1996/part_2_2017'

RSpec.describe ISO_1996::Part_2_2017 do
  describe ".background_noise_correction" do
    it "returns 0 for ΔL = 10 dB" do
      expect(described_class.background_noise_correction(70, 60)).to eq(0.0)
    end

    it "returns 0 for ΔL > 10 dB" do
      expect(described_class.background_noise_correction(70.5, 60.0)).to eq(0.0)
    end

    it "calculates correction for ΔL = 6 dB (ISO 1996-2:2017 Table D.1)" do
      # Expected value: 1.3 dB
      delta_l = 6.0
      expected = -10 * Math.log10(1 - 10**(-0.1 * delta_l))
      expect(described_class.background_noise_correction(66, 60)).to be_within(0.001).of(expected)
    end

    it "calculates correction for ΔL = 4 dB (ISO 1996-2:2017 Table D.1)" do
      # Expected value: 2.2 dB
      delta_l = 4.0
      expected = -10 * Math.log10(1 - 10**(-0.1 * delta_l))
      expect(described_class.background_noise_correction(64, 60)).to be_within(0.001).of(expected)
    end

    it "raises error for ΔL = 3 dB" do
      expect { described_class.background_noise_correction(63.0, 60.0) }
        .to raise_error(ArgumentError, "Measurement uncertain: ΔL ≤ 3.0 dB")
    end

    it "raises error for ΔL < 3 dB" do
      expect { described_class.background_noise_correction(62.9, 60.0) }
        .to raise_error(ArgumentError, "Measurement uncertain: ΔL ≤ 3.0 dB")
    end

    it "raises error for negative ΔL" do
      expect { described_class.background_noise_correction(58.0, 60.0) }
        .to raise_error(ArgumentError, "Measurement uncertain: ΔL ≤ 3.0 dB")
    end

    it "handles fractional differences" do
      # ΔL = 7.3 dB
      result = described_class.background_noise_correction(67.3, 60.0)
      expected = -10 * Math.log10(1 - 10**(-0.73))
      expect(result).to be_within(0.001).of(expected)
    end
  end

  describe ".atmospheric_absorption_correction" do
    it "calculates for typical conditions" do
      # For 100m at 0.01 dB/m attenuation
      expect(described_class.atmospheric_absorption_correction(0.01, 100)).to eq(1.0)
    end

    it "handles zero distance" do
      expect(described_class.atmospheric_absorption_correction(0.05, 0)).to eq(0.0)
    end

    it "handles zero attenuation" do
      expect(described_class.atmospheric_absorption_correction(0.0, 100)).to eq(0.0)
    end

    it "handles fractional values" do
      expect(described_class.atmospheric_absorption_correction(0.0075, 80)).to eq(0.6)
    end

    it "handles large distances" do
      expect(described_class.atmospheric_absorption_correction(0.002, 5000)).to eq(10.0)
    end

    it "handles high attenuation coefficients" do
      expect(described_class.atmospheric_absorption_correction(0.5, 10)).to eq(5.0)
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

    it "handles single component" do
      expect(described_class.measurement_uncertainty([1.5])).to eq(1.5)
    end

    it "handles fractional components" do
      uncertainties = [0.3, 0.4, 0.5]
      expected = Math.sqrt(0.3**2 + 0.4**2 + 0.5**2)
      expect(described_class.measurement_uncertainty(uncertainties)).to be_within(0.001).of(expected)
    end

    it "handles negative components" do
      uncertainties = [1.0, -0.5, 0.5] # Squares make negatives irrelevant
      expected = Math.sqrt(1.0**2 + (-0.5)**2 + 0.5**2)
      expect(described_class.measurement_uncertainty(uncertainties)).to be_within(0.001).of(expected)
    end

    it "handles very small uncertainties" do
      uncertainties = [0.01, 0.02, 0.03]
      expected = Math.sqrt(0.01**2 + 0.02**2 + 0.03**2)
      expect(described_class.measurement_uncertainty(uncertainties)).to be_within(0.0001).of(expected)
    end
  end
end
