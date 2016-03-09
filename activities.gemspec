# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activities/version'

Gem::Specification.new do |spec|
  spec.name          = "activities"
  spec.version       = Activities::VERSION
  spec.authors       = ["Jason Webster"]
  spec.email         = ["jason@metalabdesign.com"]
  spec.summary       = "Gem for creating and querying an activity feed."
  spec.description   = "Gem for creating and querying an activity feed. Activities can be scoped to any object."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
end
