# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cases/version'

Gem::Specification.new do |spec|
  spec.name          = "cases"
  spec.version       = Cases::VERSION
  spec.authors       = ["Morgan Showman"]
  spec.email         = ["mshowman@squaremouth.com"]
  spec.summary       = %q{Define cases on methods that execute different callbacks for different scenarios}
  spec.description   = %q{Define case, and caseable callbacks for your methods in ruby. By defining cases you can add callbacks
                          to your methods where different callbacks will happen based on the result of the method}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "method_callbacks"
end
