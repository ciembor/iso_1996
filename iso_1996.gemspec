# frozen_string_literal: true

require_relative 'lib/iso_1996/version'

Gem::Specification.new do |spec|
  spec.name          = "iso_1996"
  spec.version       = ISO_1996::VERSION
  spec.authors       = ["Maciej Ciemborowicz"]
  spec.email         = ["maciej.ciemborowicz@gmail.com"]
  spec.date          = Time.now.strftime("%Y-%m-%d")
  
  spec.summary       = "ISO 1996 environmental noise standards library"

  spec.description   = "Implementation of ISO 1996 noise measurement standards for Ruby applications. " \
    "Enables environmental noise assessment according to current ISO 1996-1:2016 (Basic quantities and assessment procedures) " \
    "and 1996-2:2017 (Determination of sound pressure levels) specifications, " \
    "Also contains withdrawn ISO 1996-1:2003, ISO 1996-2:2007 and ISO 1996-3:1987 " \
    "Ideal for environmental monitoring systems."
  
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
    "documentation_uri" => "https://ciembor.github.io/iso_1996",
    "source_code_uri"       => "https://github.com/ciembor/iso_1996",
    "bug_tracker_uri"       => "https://github.com/ciembor/iso_1996/issues",
  }

  spec.add_development_dependency "yard", "~> 0.9.28"
  spec.add_development_dependency "kramdown", "~> 2.4"
  spec.add_development_dependency "kramdown-parser-gfm", "~> 1.1"
  spec.add_development_dependency "redcarpet", "~> 3.5"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
