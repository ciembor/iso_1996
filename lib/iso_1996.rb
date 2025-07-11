# frozen_string_literal: true

##
# = ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise
#
# Ruby implementation of ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise.
# Includes all three parts:
# - ISO 1996-1:2003: Basic quantities and assessment procedures
# - ISO 1996-2:2007: Determination of sound pressure levels
# - ISO 1996-3:1987: Application to noise limits
#
# Author:: Maciej Ciemborowicz
# Date:: July 11, 2025
# Version:: 1.0.0
# License:: MIT
#
# == Usage
#   require 'iso_1996'
#   
#   # Basic calculations
#   level = ISO_1996::Basic.sound_pressure_level(0.1)
#   
#   # Environmental noise corrections
#   correction = ISO_1996::EnvironmentalNoise.background_noise_correction(65, 60)
#   
#   # Noise limits assessment
#   assessment = ISO_1996::NoiseLimits.assessment_level(65, 2, 3)
#
# @see https://www.iso.org/standard/28633.html ISO 1996-1:2003
# @see https://www.iso.org/standard/23776.html ISO 1996-2:2007
# @see https://www.iso.org/standard/6750.html ISO 1996-3:1987

require_relative 'iso_1996/basic'
require_relative 'iso_1996/environmental_noise'
require_relative 'iso_1996/noise_limits'

module ISO_1996
  ##
  # Current version of the gem
  VERSION = "1.0.0"
end
