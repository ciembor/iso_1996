# frozen_string_literal: true

require_relative 'lib/iso_1996'

Gem::Specification.new do |spec|
  spec.name          = "iso_1996"
  spec.version       = ISO_1996::VERSION
  spec.authors       = ["Maciej Ciemborowicz"]
  spec.email         = ["maciej.ciemborowicz@gmail.com"]
  spec.date          = Time.now.strftime("%Y-%m-%d")
  
  spec.summary       = "Implementation of ISO 1996 acoustics standards"
  spec.description   = <<~DESC
    Ruby implementation of ISO 1996 standards for environmental noise assessment.
    Includes current and withdrawn versions of:
    - ISO 1996-1 (Basic quantities and assessment procedures)
    - ISO 1996-2 (Determination of sound pressure levels)
    - ISO 1996-3 (Application to noise limits)
  DESC
  
  spec.homepage      = "https://github.com/ciembor/iso_1996"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files         = Dir[
    "lib/**/*.rb", 
    "*.md",
    "*.gemspec"
  ]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "yard.run"              => "yard",
    "documentation_uri"     => "https://rubydoc.info/gems/iso_1996",
    "source_code_uri"       => "https://github.com/ciembor/iso_1996",
    "bug_tracker_uri"       => "https://github.com/ciembor/iso_1996/issues",
    "changelog_uri"         => "https://github.com/ciembor/iso_1996/blob/main/CHANGELOG.md"
  }

  spec.add_development_dependency "yard", "~> 0.9.28"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "redcarpet", "~> 3.5"
end
