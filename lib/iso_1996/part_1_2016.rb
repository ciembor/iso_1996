# frozen_string_literal: true

module ISO_1996
  ##
  # ISO 1996-1:2016 Acoustics - Description, measurement and assessment of environmental noise - 
  # Part 1: Basic quantities and assessment procedures
  #
  # Module implementing calculations defined in ISO 1996-1:2016
  #
  # @author Maciej Ciemborowicz
  # @since 2025-07-13
  module Part_1_2016
    ##
    # Constants defined in ISO 1996-1:2016 standard
    module Constants
      ##
      # Reference sound pressure (p₀) as defined in Section 3.1.1
      # @constant
      # @return [Float] 20 μPa (20e-6 Pa)
      REFERENCE_SOUND_PRESSURE = 20e-6

      ##
      # Reference time (t₀) for sound exposure level as defined in Section 3.1.8
      # @constant
      # @return [Float] 1 second
      REFERENCE_TIME = 1.0

      ##
      # Standard duration for day period as defined in Annex C.2
      # @constant
      # @return [Float] 12.0 hours
      DAY_DURATION = 12.0
      
      ##
      # Standard duration for evening period as defined in Annex C.2
      # @constant
      # @return [Float] 4.0 hours
      EVENING_DURATION = 4.0
      
      ##
      # Standard duration for night period as defined in Annex C.2
      # @constant
      # @return [Float] 8.0 hours
      NIGHT_DURATION = 8.0

      ##
      # Penalty for evening period as defined in Annex C.2
      # @constant
      # @return [Float] 5.0 dB
      EVENING_PENALTY = 5.0
      
      ##
      # Penalty for night period as defined in Annex C.2
      # @constant
      # @return [Float] 10.0 dB
      NIGHT_PENALTY = 10.0
    end
    include Constants

    ##
    # Calculate sound pressure level (L_p) as defined in Section 3.1.2
    #
    # @math L_p = 10 \log_{10}\left(\frac{p^2}{p_0^2}\right) \text{ dB}
    #
    # @param p [Float] Root-mean-square sound pressure (Pa)
    # @return [Float] Sound pressure level in dB
    #
    # @example Calculate for 0.1 Pa
    #   Part_1_2016.sound_pressure_level(0.1) # => 74.0
    #
    def self.sound_pressure_level(p)
      10 * Math.log10((p ** 2) / (Constants::REFERENCE_SOUND_PRESSURE ** 2))
    end

    ##
    # Calculate sound exposure level (L_AE) as defined in Section 3.1.8
    #
    # @math L_{AE} = 10 \log_{10}\left(\frac{1}{t_0} \cdot \frac{p_A^2}{p_0^2}\right) \text{ dB}
    #
    # @param p_a [Float] A-weighted sound pressure (Pa)
    # @return [Float] Sound exposure level in dB
    #
    # @note This method assumes a single value for simplicity.
    #       For time-varying signals, integration over time is required.
    #
    def self.sound_exposure_level(p_a)
      10 * Math.log10((1.0 / Constants::REFERENCE_TIME) * (p_a ** 2) / (Constants::REFERENCE_SOUND_PRESSURE ** 2))
    end

    ##
    # Calculate equivalent continuous sound level (L_Aeq,T) as defined in Section 3.1.7
    #
    # @math L_{Aeq,T} = 10 \log_{10}\left(\frac{1}{T} \sum 10^{0.1L_i}\right) \text{ dB}
    #
    # @param levels [Array<Float>] Array of sound pressure levels (dB)
    # @param measurement_time [Float] Total measurement time (seconds)
    # @return [Float] Equivalent continuous sound level in dB
    # @raise [ArgumentError] if measurement_time is not positive
    #
    # @example Calculate for 3 measurements
    #   levels = [65.0, 67.0, 63.0]
    #   Part_1_2016.equivalent_continuous_sound_level(levels, 3.0) # => ~65.1
    #
    def self.equivalent_continuous_sound_level(levels, measurement_time)
      raise ArgumentError, "Measurement time must be positive" if measurement_time <= 0
      return -Float::INFINITY if levels.empty?

      energy_sum = levels.sum { |l| 10 ** (l / 10.0) }
      10 * Math.log10(energy_sum / measurement_time)
    end

    ##
    # Calculate peak sound pressure level (L_pC,peak) as defined in Section 3.1.10
    #
    # @math L_{pC,peak} = 20 \log_{10}\left(\frac{p_{Cmax}}{p_0}\right) \text{ dB}
    #
    # @param p_c_max [Float] Maximum C-weighted sound pressure (Pa)
    # @return [Float] Peak sound pressure level in dB
    #
    def self.peak_sound_pressure_level(p_c_max)
      20 * Math.log10(p_c_max / Constants::REFERENCE_SOUND_PRESSURE)
    end

    ##
    # Calculate day-evening-night level (L_den) as defined in Annex C.2
    #
    # @math L_{den} = 10 \log_{10}\left(\frac{1}{24}\left[t_d10^{L_{day}/10} + t_e10^{(L_{evening}+P_e)/10} + t_n10^{(L_{night}+P_n)/10}\right]\right) \text{ dB}
    #
    # @param l_day [Float] Day-time equivalent sound level (dB)
    # @param l_evening [Float] Evening-time equivalent sound level (dB)
    # @param l_night [Float] Night-time equivalent sound level (dB)
    # @param day_duration [Float] Duration of day period (hours)
    # @param evening_duration [Float] Duration of evening period (hours)
    # @param night_duration [Float] Duration of night period (hours)
    # @param evening_penalty [Float] Penalty for evening period (dB)
    # @param night_penalty [Float] Penalty for night period (dB)
    # @return [Float] Day-evening-night level in dB
    #
    # @example Standard case
    #   Part_1_2016.day_evening_night_level(65.0, 62.0, 58.0) # => ~67.1
    #
    def self.day_evening_night_level(l_day, l_evening, l_night,
                                    day_duration: Constants::DAY_DURATION,
                                    evening_duration: Constants::EVENING_DURATION,
                                    night_duration: Constants::NIGHT_DURATION,
                                    evening_penalty: Constants::EVENING_PENALTY,
                                    night_penalty: Constants::NIGHT_PENALTY)
      total_hours = day_duration + evening_duration + night_duration
      
      term_day = day_duration * 10 ** (l_day / 10.0)
      term_evening = evening_duration * 10 ** ((l_evening + evening_penalty) / 10.0)
      term_night = night_duration * 10 ** ((l_night + night_penalty) / 10.0)
      
      10 * Math.log10((term_day + term_evening + term_night) / total_hours)
    end

    ##
    # Determine tonal adjustment factor (K_T) as defined in Annex D.3
    #
    # @param is_audible [Boolean] Whether the tone is clearly audible
    # @param is_prominent [Boolean] Whether the tone is prominent
    # @return [Float] Tonal adjustment factor in dB (0.0, 3.0, or 6.0)
    #
    # @note According to Annex D.3:
    #   - Prominent tone: 6 dB
    #   - Clearly audible but not prominent: 3 dB
    #   - Not clearly audible: 0 dB
    #
    def self.tonal_adjustment_factor(is_audible: false, is_prominent: false)
      return 0.0 unless is_audible
      return 6.0 if is_prominent
      3.0
    end

    ##
    # Determine impulsive adjustment factor (K_I) as defined in Annex D.4
    #
    # @param is_audible [Boolean] Whether the impulsive sound is clearly audible
    # @param is_distinct [Boolean] Whether the impulsive sound is distinct
    # @return [Float] Impulsive adjustment factor in dB (0.0, 3.0, or 6.0)
    #
    # @note According to Annex D.4:
    #   - Distinct impulsive sound: 6 dB
    #   - Clearly audible but not distinct: 3 dB
    #   - Not clearly audible: 0 dB
    #
    def self.impulsive_adjustment_factor(is_audible: false, is_distinct: false)
      return 0.0 unless is_audible
      return 6.0 if is_distinct
      3.0
    end

    ##
    # Calculate assessment level (L_r) as defined in Section 3.6
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
    # Evaluate compliance with noise limits as defined in Section 9.2
    #
    # @param assessment_level [Float] Calculated assessment level (dB)
    # @param noise_limit [Float] Applicable noise limit (dB)
    # @param measurement_uncertainty [Float] Measurement uncertainty (dB)
    # @return [Boolean] True if limit is exceeded
    #
    # @note Returns true when assessment_level > noise_limit + measurement_uncertainty
    #
    def self.compliance_evaluation(assessment_level, noise_limit, measurement_uncertainty)
      assessment_level > noise_limit + measurement_uncertainty
    end
  end
end
