# frozen_string_literal: true

module ISO_1996
  module Withdrawn
    ##
    # ISO 1996-3:1987 Application to Noise Limits
    #
    # Module implementing calculations defined in ISO 1996-3:1987:
    # "Acoustics - Description, measurement and assessment of environmental noise - 
    # Part 3: Application to noise limits"
    #
    # @author Maciej Ciemborowicz
    # @since 2025-07-11
    module Part_3_1987
      ##
      # Constants defined in ISO 1996-3:1987 standard
      module Constants
        ##
        # Impulse correction threshold (L_Cpeak,min) as defined in Section 7.2
        #
        # @constant
        # @return [Float] 130.0 dB
        IMPULSE_CORRECTION_THRESHOLD = 130.0

        ##
        # Standard 24-hour period as defined in Annex A
        #
        # @constant
        # @return [Float] 24.0 hours
        STANDARD_24H_PERIOD = 24.0
      end
      include Constants

      ##
      # Determine tonal adjustment factor (K_T) as defined in Section 6 and Table 1
      #
      # @param delta_l [Float] Difference between tone level and background level (dB)
      # @return [Float] Tonal adjustment factor in dB
      #
      # @note According to Table 1:
      #   - ΔL ≥ 15 dB → 6 dB
      #   - 10 ≤ ΔL ≤ 14 dB → 5 dB
      #   - 5 ≤ ΔL ≤ 9 dB → 2 dB
      #   - ΔL < 5 dB → 0 dB
      #
      def self.tonal_adjustment_factor(delta_l)
        case delta_l
        when 15..Float::INFINITY then 6.0
        when 10..14 then 5.0
        when 5..9  then 2.0
        else 0.0
        end
      end

      ##
      # Determine impulsive adjustment factor (K_I) as defined in Section 7.2
      #
      # @param l_cpeak [Float] C-weighted peak sound pressure level (dB)
      # @param is_highly_annoying [Boolean] Whether noise is subjectively assessed as highly annoying
      # @return [Float] Impulsive adjustment factor in dB
      #
      # @note Returns 6 dB if L_Cpeak ≥ 130 dB OR noise is highly annoying, otherwise 0 dB
      #
      def self.impulsive_adjustment_factor(l_cpeak, is_highly_annoying: false)
        (l_cpeak >= Constants::IMPULSE_CORRECTION_THRESHOLD || is_highly_annoying) ? 6.0 : 0.0
      end

      ##
      # Calculate assessment level (L_r) as defined in Section 8
      #
      # @math L_r = L_{AeqT} + K_T + K_I \text{ dB}
      #
      # @param l_aeq_t [Float] Equivalent continuous A-weighted sound pressure level (dB)
      # @param k_t [Float] Tonal adjustment factor (dB)
      # @param k_i [Float] Impulsive adjustment factor (dB)
      # @return [Float] Assessment level in dB
      #
      def self.assessment_level(l_aeq_t, k_t, k_i)
        l_aeq_t + k_t + k_i
      end

      ##
      # Evaluate compliance with noise limits as defined in Section 9
      #
      # @param l_r [Float] Assessment level (dB)
      # @param noise_limit [Float] Noise limit value (dB)
      # @param measurement_uncertainty [Float] Measurement uncertainty (dB)
      # @return [Boolean] True if limit is exceeded (L_r > noise_limit + measurement_uncertainty)
      #
      def self.compliance_evaluation(l_r, noise_limit, measurement_uncertainty)
        l_r > noise_limit + measurement_uncertainty
      end

      ##
      # Convert sound levels between time periods as defined in Annex A
      #
      # @math L_{\mathrm{total}} = 10 \log_{10}\left(\frac{\sum(t_i \cdot 10^{0.1L_i})}{T_{\mathrm{total}}}\right) \text{ dB}
      #
      # @param period_levels [Array<Hash>] Array of hashes with :level (dB) and :duration (hours)
      # @param total_period [Float] Total time period for normalization (hours)
      # @return [Float] Equivalent sound level for total period in dB
      #
      # @example Convert day and night levels to 24-hour equivalent
      #   periods = [
      #     {level: 65.0, duration: 16}, # Day
      #     {level: 55.0, duration: 8}   # Night
      #   ]
      #   Part_3_1987.time_period_conversion(periods) # => ~62.1
      #
      def self.time_period_conversion(period_levels, total_period: Constants::STANDARD_24H_PERIOD)
        energy_sum = period_levels.sum { |period| period[:duration] * (10 ** (period[:level] / 10.0)) }
        10 * Math.log10(energy_sum / total_period)
      end
    end
  end
end
