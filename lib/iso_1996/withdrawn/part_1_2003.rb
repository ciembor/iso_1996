# frozen_string_literal: true

module ISO_1996
  ##
  # Withdrawn standards
  #
  module Withdrawn

    ##
    # ISO 1996-1:2003 Basic Quantities and Assessment Procedures
    #
    # Module implementing calculations defined in ISO 1996-1:2003:
    # "Acoustics - Description, measurement and assessment of environmental noise - 
    # Part 1: Basic quantities and assessment procedures"
    #
    # @author Maciej Ciemborowicz
    # @since 2025-07-11
    #
    module Part_1_2003
      ##
      # Constants defined in ISO 1996-1:2003 standard
      module Constants
        ##
        # Reference sound pressure (p₀) as defined in Section 3.1
        #
        # @constant
        # @return [Float] 20 μPa (20e-6 Pa)
        REFERENCE_SOUND_PRESSURE = 20e-6

        ##
        # Reference time (t₀) for sound exposure level as defined in Section 3.9
        #
        # @constant
        # @return [Float] 1 second
        REFERENCE_TIME = 1.0
      end
      include Constants

      ##
      # Calculate sound pressure level (L_p) as defined in Section 3.2
      #
      # @math L_p = 10 \log_{10}\left(\frac{p^2}{p_0^2}\right) \text{ dB}
      #
      # @param p [Float] Root-mean-square sound pressure (Pa)
      # @return [Float] Sound pressure level in dB
      #
      # @example
      #   Part_1_2003.sound_pressure_level(0.1) # => 74.0
      #
      def self.sound_pressure_level(p)
        10 * Math.log10((p ** 2) / (Constants::REFERENCE_SOUND_PRESSURE ** 2))
      end

      ##
      # Calculate A-weighted sound pressure level (L_A) as defined in Section 3.2
      #
      # @math L_A = 10 \log_{10}\left(\frac{1}{T} \cdot \frac{p_A^2}{p_0^2}\right) \text{ dB}
      #
      # @param p_a [Float] A-weighted sound pressure (Pa)
      # @param measurement_time [Float] Measurement time interval (seconds)
      # @return [Float] A-weighted sound pressure level in dB
      #
      def self.a_weighted_sound_pressure_level(p_a, measurement_time: 1.0)
        10 * Math.log10((1.0 / measurement_time) * (p_a ** 2) / (Constants::REFERENCE_SOUND_PRESSURE ** 2))
      end

      ##
      # Calculate sound exposure level (L_AE) as defined in Section 3.9
      #
      # @math L_{AE} = 10 \log_{10}\left(\frac{1}{t_0} \cdot \frac{p_A^2}{p_0^2}\right) \text{ dB}
      #
      # @param p_a [Float] A-weighted sound pressure (Pa)
      # @return [Float] Sound exposure level in dB
      #
      def self.sound_exposure_level(p_a)
        10 * Math.log10((1.0 / Constants::REFERENCE_TIME) * (p_a ** 2) / (Constants::REFERENCE_SOUND_PRESSURE ** 2))
      end

      ##
      # Calculate equivalent continuous sound level (L_Aeq,T) as defined in Section 3.7
      #
      # @math L_{Aeq,T} = 10 \log_{10}\left(\frac{1}{T} \sum 10^{0.1L_i}\right) \text{ dB}
      #
      # @param levels [Array<Float>] Array of sound pressure levels (dB)
      # @param measurement_time [Float] Total measurement time (seconds)
      # @return [Float] Equivalent continuous sound level in dB
      # @raise [ArgumentError] if measurement_time is not positive
      #
      # @example
      #   levels = [65.0, 67.0, 63.0]
      #   Part_1_2003.equivalent_continuous_sound_level(levels, 3.0) # => ~65.1
      #
      def self.equivalent_continuous_sound_level(levels, measurement_time)
        raise ArgumentError, "Measurement time must be positive" if measurement_time <= 0
        
        return -Float::INFINITY if levels.empty?

        energy_sum = levels.sum { |l| 10 ** (l / 10.0) }
        10 * Math.log10(energy_sum / measurement_time)
      end

      ##
      # Calculate C-weighted peak sound pressure level (L_Cpeak) as defined in Section 3.10
      #
      # @math L_{Cpeak} = 20 \log_{10}\left(\frac{p_{Cmax}}{p_0}\right) \text{ dB}
      #
      # @param p_c_max [Float] Maximum C-weighted sound pressure (Pa)
      # @return [Float] C-weighted peak sound pressure level in dB
      #
      def self.peak_sound_pressure_level(p_c_max)
        20 * Math.log10(p_c_max / Constants::REFERENCE_SOUND_PRESSURE)
      end
    end
  end
end
