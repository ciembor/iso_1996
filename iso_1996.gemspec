# frozen_string_literal: true

require_relative 'lib/iso_1996.rb'

Gem::Specification.new do |spec|
  spec.name          = "iso_1996"
  spec.version       = ISO_1996::VERSION
  spec.authors       = ["Maciej Ciemborowicz"]
  spec.email         = ["maciej.ciemborowicz@gmail.com"]
  spec.date          = "2025-07-11"
  
  spec.summary       = "Implementation of ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise"
  spec.description   = <<-DESC
    Ruby implementation of ISO 1996 - Acoustics - Description, measurement and assessment of environmental noise.
    Includes all three parts:
    - ISO 1996-1:2003: Basic quantities and assessment procedures
    - ISO 1996-2:2007: Determination of sound pressure levels
    - ISO 1996-3:1987: Application to noise limits
  DESC
  spec.homepage      = "https://github.com/ciembor/iso_1996"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + ["README.md"]
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rdoc", "~> 6.5"
  
  spec.metadata = {
    "documentation_uri" => "https://rubydoc.info/gems/iso_1996",
    "source_code_uri"   => "https://github.com/ciembor/iso_1996"
  }
end
