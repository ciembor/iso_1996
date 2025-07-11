# frozen_string_literal: true

module ISO_1996

  ##
  # == ISO 1996-2:2007 Determination of Sound Pressure Levels
  #
  # Module implementing calculations defined in ISO 1996-2:2007:
  # "Acoustics - Description, measurement and assessment of environmental noise - 
  # Part 2: Determination of sound pressure levels"
  #
  # Author:: Maciej Ciemborowicz
  # Date:: July 11, 2025
  #
  module EnvironmentalNoise
    ##
    # Constants defined in ISO 1996-2:2007 standard
    module Constants
      ##
      # Minimum level difference for background correction (ΔL_min) as defined in Section 6.3
      # Value: 3 dB
      MIN_BACKGROUND_LEVEL_DIFFERENCE = 3.0 # dB

      ##
      # Threshold for background correction (ΔL_threshold) as defined in Section 6.3
      # Value: 10 dB
      BACKGROUND_CORRECTION_THRESHOLD = 10.0 # dB
    end
    include Constants

    ##
    # Calculate background noise correction (K₁) as defined in Section 6.3 and Annex D
    #
    # K₁ = -10 * log10(1 - 10^(-0.1 * ΔL)) dB
    # where ΔL = L_total - L_background
    #
    # @param l_total [Float] Total sound pressure level (dB)
    # @param l_background [Float] Background sound pressure level (dB)
    # @return [Float] Background noise correction in dB
    # @raise [ArgumentError] if ΔL ≤ 3 dB (measurement uncertain)
    #
    # Example:
    #   EnvironmentalNoise.background_noise_correction(65, 60) # => 1.7 dB
    #
    def self.background_noise_correction(l_total, l_background)
      delta_l = l_total - l_background

      if delta_l <= Constants::MIN_BACKGROUND_LEVEL_DIFFERENCE
        raise ArgumentError, "Measurement uncertain: ΔL ≤ #{Constants::MIN_BACKGROUND_LEVEL_DIFFERENCE} dB"
      elsif delta_l >= Constants::BACKGROUND_CORRECTION_THRESHOLD
        0.0
      else
        -10 * Math.log10(1 - 10 ** (-0.1 * delta_l))
      end
    end

    ##
    # Calculate atmospheric absorption correction (A_atm) as defined in Section 7.3 and Annex A
    #
    # A_atm = α * d dB
    #
    # @param attenuation_coefficient [Float] Atmospheric attenuation coefficient (dB/m)
    # @param propagation_distance [Float] Sound propagation distance (m)
    # @return [Float] Atmospheric absorption correction in dB
    #
    def self.atmospheric_absorption_correction(attenuation_coefficient, propagation_distance)
      attenuation_coefficient * propagation_distance
    end

    ##
    # Calculate combined measurement uncertainty as defined in Section 9
    #
    # u_total = √(Σ(u_i²)) dB
    #
    # @param uncertainty_components [Array<Float>] Array of uncertainty components (dB)
    # @return [Float] Combined measurement uncertainty in dB
    #
    # Example:
    #   EnvironmentalNoise.measurement_uncertainty([0.5, 1.0, 0.7]) # => 1.28 dB
    #
    def self.measurement_uncertainty(uncertainty_components)
      Math.sqrt(uncertainty_components.sum { |c| c ** 2 })
    end
  end
end