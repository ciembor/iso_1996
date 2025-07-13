
# ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise Ruby library.

[![Gem Version](https://badge.fury.io/rb/iso_1996.svg)](https://badge.fury.io/rb/iso_1996)
[![Documentation](https://img.shields.io/badge/docs-rdoc.info-blue)](https://rubydoc.info/gems/iso_1996)

Ruby implementation of ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise. 
Provides complete calculations for environmental noise assessment according to ISO 1996-1:2016 and ISO 1996-2:2017 standards.

## Features

- Complete implementation of ISO 1996-1:2016 and ISO 1996-2:2017
- Calculation of all key acoustic metrics
- Environmental corrections and uncertainty analysis
- Day-evening-night level (L<sub>den</sub>) assessment
- Fully documented with RDoc comments
- Comprehensive test suite
- MIT licensed

## Installation

Add to your Gemfile:

```ruby
gem 'iso_1996'
```

Or install directly:

```bash
gem install iso_1996
```

## Documentation
Full documentation available at:
https://rubydoc.info/gems/iso_1996

## Example Usage

```ruby
require 'iso_1996'

# ----------------------------------------------------------
# STEP 1: Data Collection - 6 measurements from sound level meter
# ----------------------------------------------------------
measurements = [
  # Continuous measurements (A-weighted, 1-min each)
  { time: Time.now - 300, pressure: 0.08, weighting: 'A', duration: 60 },
  { time: Time.now - 240, pressure: 0.12, weighting: 'A', duration: 60 },
  { time: Time.now - 180, pressure: 0.15, weighting: 'A', duration: 60 },
  { time: Time.now - 120, pressure: 0.10, weighting: 'A', duration: 60 },
  { time: Time.now - 60,  pressure: 0.18, weighting: 'A', duration: 60 },
  
  # Impulse measurement (C-weighted, 100ms)
  { time: Time.now,       pressure: 0.25, weighting: 'C', duration: 0.1 }
]

# Background measurement (5-min average)
background = { pressure: 0.05, weighting: 'A', duration: 300 }

# ----------------------------------------------------------
# STEP 2: Calculate Basic Sound Levels (ISO 1996-1:2016)
# ----------------------------------------------------------

# Calculate SPL for each measurement
measurements.each do |m|
  m[:spl] = ISO_1996::Part_1_2016.sound_pressure_level(m[:pressure])
end

# Calculate equivalent continuous sound level (L_Aeq)
a_weighted = measurements.select { |m| m[:weighting] == 'A' }
l_aeq = ISO_1996::Part_1_2016.equivalent_continuous_sound_level(
  a_weighted.map { |m| m[:spl] },
  a_weighted.sum { |m| m[:duration] }
)

# Calculate peak sound pressure level (L_Cpeak)
impulse = measurements.find { |m| m[:weighting] == 'C' }
l_cpeak = ISO_1996::Part_1_2016.peak_sound_pressure_level(impulse[:pressure])

# ----------------------------------------------------------
# STEP 3: Environmental Corrections (ISO 1996-2:2017)
# ----------------------------------------------------------

# Calculate background noise correction
background_spl = ISO_1996::Part_1_2016.sound_pressure_level(background[:pressure])
background_correction = ISO_1996::Part_2_2017.background_noise_correction(l_aeq, background_spl)

# Apply atmospheric absorption correction
attenuation_coefficient = 0.005  # dB/m (from ISO 9613-1 based on temp/humidity)
distance = 50.0  # meters
atmospheric_correction = ISO_1996::Part_2_2017.atmospheric_absorption_correction(
  attenuation_coefficient, distance
)

# Calculate total correction
corrected_l_aeq = l_aeq - background_correction - atmospheric_correction

# ----------------------------------------------------------
# STEP 4: Day-Evening-Night Level Calculation (L_den) (ISO 1996-1:2016)
# ----------------------------------------------------------

# Normally collected separately for each period
day_measurements = [65.2, 67.1, 66.5]   # 3-hour measurements
evening_measurements = [63.8, 62.4]      # 2-hour measurements
night_measurements = [58.7, 57.9, 59.3]  # 3-hour measurements

# Calculate L_Aeq for each period
l_day = ISO_1996::Part_1_2016.equivalent_continuous_sound_level(day_measurements, 3 * 3600)
l_evening = ISO_1996::Part_1_2016.equivalent_continuous_sound_level(evening_measurements, 2 * 3600)
l_night = ISO_1996::Part_1_2016.equivalent_continuous_sound_level(night_measurements, 3 * 3600)

# Calculate L_den with standard penalties
l_den = ISO_1996::Part_1_2016.day_evening_night_level(l_day, l_evening, l_night)

# ----------------------------------------------------------
# STEP 5: Assessment Procedures (ISO 1996-1:2016)
# ----------------------------------------------------------

# Determine adjustment factors (requires professional judgment)
is_tonal_audible = true   # Based on spectral analysis
is_tonal_prominent = false
k_t = ISO_1996::Part_1_2016.tonal_adjustment_factor(
  is_audible: is_tonal_audible, 
  is_prominent: is_tonal_prominent
)

is_impulse_audible = true
is_impulse_distinct = true
k_i = ISO_1996::Part_1_2016.impulsive_adjustment_factor(
  is_audible: is_impulse_audible,
  is_distinct: is_impulse_distinct
)

# Calculate assessment level
assessment_level = ISO_1996::Part_1_2016.assessment_level(corrected_l_aeq, k_t, k_i)

# ----------------------------------------------------------
# STEP 6: Compliance Evaluation
# ----------------------------------------------------------
noise_limit = 65.0  # dB(A) - local regulation
uncertainty_components = [0.5, 1.0, 0.7]  # Instrument, position, environmental
measurement_uncertainty = ISO_1996::Part_2_2017.measurement_uncertainty(uncertainty_components)

is_compliant = !ISO_1996::Part_1_2016.compliance_evaluation(
  assessment_level, 
  noise_limit, 
  measurement_uncertainty
)

# ----------------------------------------------------------
# STEP 7: Reporting
# ----------------------------------------------------------
puts "Environmental Noise Assessment Report"
puts "------------------------------------"
puts "Measurement Period: #{measurements.first[:time]} to #{measurements.last[:time]}"
puts "Equivalent Continuous Level (L_Aeq): #{l_aeq.round(1)} dB(A)"
puts "Background Correction: #{background_correction.round(1)} dB"
puts "Atmospheric Correction: #{atmospheric_correction.round(1)} dB"
puts "Corrected L_Aeq: #{corrected_l_aeq.round(1)} dB(A)"
puts "Tonal Adjustment (K_T): #{k_t} dB"
puts "Impulsive Adjustment (K_I): #{k_i} dB"
puts "Assessment Level (L_r): #{assessment_level.round(1)} dB(A)"
puts "Day Level (L_day): #{l_day.round(1)} dB(A)"
puts "Evening Level (L_evening): #{l_evening.round(1)} dB(A)"
puts "Night Level (L_night): #{l_night.round(1)} dB(A)"
puts "Day-Evening-Night Level (L_den): #{l_den.round(1)} dB(A)"
puts "Peak Sound Level (L_Cpeak): #{l_cpeak.round(1)} dB(C)"
puts "Noise Limit: #{noise_limit} dB(A)"
puts "Measurement Uncertainty: ±#{measurement_uncertainty.round(1)} dB"
puts "Compliance Status: #{is_compliant ? 'PASS' : 'FAIL'}"
puts "------------------------------------"
```

## Handling Non-formula Aspects of the Standard
The ISO 1996 standards contain important guidance that isn't expressed in formulas but requires professional judgment:

1. Tonal and Impulsive Character Assessment:
  - Use the tonal_adjustment_factor and impulsive_adjustment_factor methods with parameters based on:
    * Spectral analysis (FFT) to identify prominent tones
    * Auditory assessment by trained professionals
    * Historical data and community complaints
2. Meteorological Conditions:
  - Measure and apply corrections for:
    * Wind speed and direction (affects sound propagation)
    * Temperature gradients (affects refraction)
    * Humidity (affects high-frequency absorption)
    * Use ISO 9613-1 for detailed atmospheric absorption coefficients
3. Measurement Uncertainty:
  - Calculate using the measurement_uncertainty method with components:
    * Instrument calibration uncertainty
    * Measurement position uncertainty
    * Environmental conditions uncertainty
4. Time Period Handling:
  - For day-evening-night calculations:
    * Collect separate measurements for each period
    * Use local definitions for period boundaries (e.g., day: 7:00-19:00)
    * Apply appropriate penalties (standard is 5 dB evening, 10 dB night)

## Contributing
Bug reports and pull requests are welcome on GitHub at:
https://github.com/ciembor/iso_1996

## License
The gem is available as open source under the terms of the MIT License.

## Author
Maciej Ciemborowicz
July 11, 2025
