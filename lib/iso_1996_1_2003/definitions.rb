# lib/iso_1996_1_2003/definitions.rb

# frozen_string_literal: true

# ISO_1996_1_2003 module implements definitions from ISO 1996-1:2003 standard
# related to acoustics and environmental noise descriptors.
#
# @author Maciej Ciemborowicz
# @version 0.1
# @since 2025-06-26
#
# It includes definitions for:
# - Weighting types (A, C, Z)
# - Sound level metrics (e.g., LAeq, Lden, Lnight)
# - Periods of day (day, evening, night) with penalties
# - Adjustment types (e.g., tonality, impulsiveness)
# - Sound event types (e.g., single, continuous)
# - AcousticDescriptor class linking metric + weighting + description
#
# This module is meant to serve as a base for calculation and analysis tools
# that implement the ISO 1996-1:2003 standard.
module ISO_1996_1_2003
  class WeightingType
    attr_reader :key

    def initialize(key)
      @key = key.to_sym
    end

    A = new(:A)
    C = new(:C)
    Z = new(:Z) # Flat

    ALL = [A, C, Z].freeze

    def to_s = key.to_s
    def ==(other) = other.is_a?(WeightingType) && key == other.key
    alias eql? ==
    def hash = key.hash
  end

  class LevelMetric
    attr_reader :key

    def initialize(key)
      @key = key.to_sym
    end

    LAeq    = new(:LAeq)
    LAE     = new(:LAE)
    LAmax   = new(:LAmax)
    LCpeak  = new(:LCpeak)
    LR      = new(:LR)
    Lden    = new(:Lden)
    Lnight  = new(:Lnight)

    ALL = [LAeq, LAE, LAmax, LCpeak, LR, Lden, Lnight].freeze

    def to_s = key.to_s
    def ==(other) = other.is_a?(LevelMetric) && key == other.key
    alias eql? ==
    def hash = key.hash
  end

  class AcousticDescriptor
    attr_reader :metric, :weighting, :description

    def initialize(metric:, weighting:, description:)
      @metric = metric
      @weighting = weighting
      @description = description
    end

    def to_s
      "#{metric}(#{weighting}) – #{description}"
    end
  end

  class PeriodOfDay
    attr_reader :key, :hours, :penalty_db

    def initialize(key, hours:, penalty_db: 0)
      @key = key.to_sym
      @hours = hours
      @penalty_db = penalty_db
    end

    DAY = new(:day, hours: (7...19).to_a, penalty_db: 0)
    EVENING = new(:evening, hours: (19...23).to_a, penalty_db: 5)
    NIGHT = new(:night, hours: [23, 0, 1, 2, 3, 4, 5, 6], penalty_db: 10)

    ALL = [DAY, EVENING, NIGHT].freeze

    def to_s = key.to_s
    def ==(other) = other.is_a?(PeriodOfDay) && key == other.key
    alias eql? ==
    def hash = key.hash
  end

  class AdjustmentType
    attr_reader :key

    def initialize(key)
      @key = key.to_sym
    end

    IMPULSIVENESS = new(:impulsiveness)
    TONALITY      = new(:tonality)
    LOW_FREQUENCY = new(:low_frequency)
    OTHER         = new(:other)

    ALL = [IMPULSIVENESS, TONALITY, LOW_FREQUENCY, OTHER].freeze

    def to_s = key.to_s
    def ==(other) = other.is_a?(AdjustmentType) && key == other.key
    alias eql? ==
    def hash = key.hash
  end

  class SoundEventType
    attr_reader :key

    def initialize(key)
      @key = key.to_sym
    end

    SINGLE     = new(:single_event)
    REPETITIVE = new(:repetitive_event)
    CONTINUOUS = new(:continuous)
    IMPULSIVE  = new(:impulsive)

    ALL = [SINGLE, REPETITIVE, CONTINUOUS, IMPULSIVE].freeze

    def to_s = key.to_s
    def ==(other) = other.is_a?(SoundEventType) && key == other.key
    alias eql? ==
    def hash = key.hash
  end

  DESCRIPTORS = [
    AcousticDescriptor.new(metric: LevelMetric::LAeq, weighting: WeightingType::A, description: "Equivalent continuous A-weighted sound level"),
    AcousticDescriptor.new(metric: LevelMetric::LAE, weighting: WeightingType::A, description: "Sound exposure level (A-weighted)"),
    AcousticDescriptor.new(metric: LevelMetric::LAmax, weighting: WeightingType::A, description: "Maximum A-weighted sound level"),
    AcousticDescriptor.new(metric: LevelMetric::LCpeak, weighting: WeightingType::C, description: "Peak C-weighted sound level"),
    AcousticDescriptor.new(metric: LevelMetric::LR, weighting: nil, description: "Rating level with adjustments"),
    AcousticDescriptor.new(metric: LevelMetric::Lden, weighting: WeightingType::A, description: "Day-Evening-Night level"),
    AcousticDescriptor.new(metric: LevelMetric::Lnight, weighting: WeightingType::A, description: "Night noise level")
  ].freeze
end
