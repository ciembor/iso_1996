# frozen_string_literal: true

module ISO_1996
  module Withdrawn
    ##
    # ISO 1996-2:2007 Determination of Sound Pressure Levels
    #
    # Module implementing calculations defined in ISO 1996-2:2007:
    # "Acoustics - Description, measurement and assessment of environmental noise - 
    # Part 2: Determination of sound pressure levels"
    #
    # @author Maciej Ciemborowicz
    # @since 2025-07-11
    module Part_2_2007
      ##
      # Constants defined in ISO 1996-2:2007 standard
      module Constants
        ##
        # Minimum level difference for background correction (ΔL_min) as defined in Section 6.3
        #
        # @constant
        # @return [Float] 3.0 dB
        MIN_BACKGROUND_LEVEL_DIFFERENCE = 3.0

        ##
        # Threshold for background correction (ΔL_threshold) as defined in Section 6.3
        #
        # @constant
        # @return [Float] 10.0 dB
        BACKGROUND_CORRECTION_THRESHOLD = 10.0
      end
      include Constants

      ##
      # Calculate background noise correction (K₁) as defined in Section 6.3 and Annex D
      #
      # @math K_1 = -10 \log_{10}(1 - 10^{-0.1 \Delta L}) \text{ dB}
      # where @math \Delta L = L_{\mathrm{total}} - L_{\mathrm{background}}
      #
      # @param l_total [Float] Total sound pressure level (dB)
      # @param l_background [Float] Background sound pressure level (dB)
      # @return [Float] Background noise correction in dB
      # @raise [ArgumentError] if ΔL ≤ 3 dB (measurement uncertain)
      #
      # @example
      #   Part_2_2007.background_noise_correction(65, 60) # => 1.7
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
      # @math A_{\mathrm{atm}} = \alpha \cdot d \text{ dB}
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
      # @math u_{\mathrm{total}} = \sqrt{\sum u_i^2} \text{ dB}
      #
      # @param uncertainty_components [Array<Float>] Array of uncertainty components (dB)
      # @return [Float] Combined measurement uncertainty in dB
      #
      # @example
      #   Part_2_2007.measurement_uncertainty([0.5, 1.0, 0.7]) # => 1.28
      #
      def self.measurement_uncertainty(uncertainty_components)
        Math.sqrt(uncertainty_components.sum { |c| c ** 2 })
      end
    end
  end
end
