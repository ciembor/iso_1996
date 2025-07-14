# frozen_string_literal: true

require_relative 'iso_1996/withdrawn/part_1_2003'
require_relative 'iso_1996/withdrawn/part_2_2007'
require_relative 'iso_1996/withdrawn/part_3_1987'
require_relative 'iso_1996/part_1_2016'
require_relative 'iso_1996/part_2_2017'

##
# = ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise
#
# Ruby implementation of ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise.
# Includes current parts:
# - ISO 1996-1:2016: Basic quantities and assessment procedures
# - ISO 1996-2:2017: Determination of sound pressure levels
# As well as some legacy norms:
# - ISO 1996-1:2003: Basic quantities and assessment procedures
# - ISO 1996-2:2007: Determination of sound pressure levels
# - ISO 1996-3:1987: Application to noise limits
#
# Author:: Maciej Ciemborowicz
# Date:: July 11, 2025
# Version:: 2.0.1
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
# @see https://www.iso.org/standard/59765.html ISO 1996-1:2016
# @see https://www.iso.org/standard/59766.html ISO 1996-2:2017
#
# @see https://www.iso.org/standard/28633.html ISO 1996-1:2003
# @see https://www.iso.org/standard/23776.html ISO 1996-2:2007
# @see https://www.iso.org/standard/6750.html ISO 1996-3:1987
#
module ISO_1996
  ##
  # Current version of the gem
  VERSION = "2.0.1"
end
