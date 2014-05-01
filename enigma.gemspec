# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enigma/version'

Gem::Specification.new do |spec|
  spec.name          = "enigma"
  spec.version       = Enigma::VERSION
  spec.authors       = ["Gabe Marshall"]
  spec.email         = ["gabemarshall@me.com"]
  spec.summary       = "A command line character encoder/decoder -- results are directly copied to the clipboard for windows and mac"
  spec.description   = 
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["enigma"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
