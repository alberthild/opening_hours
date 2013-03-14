# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opening_hours/version'

Gem::Specification.new do |gem|
  gem.name          = "opening_hours"
  gem.version       = OpeningHours::VERSION
  gem.authors       = ["Albert Hild"]
  gem.email         = ["mail@albert-hild.de"]
  gem.description   = %q{Opening hours for all kind of businesses}
  gem.summary       = %q{Let you apply opening hours, closed periods and holidays to all kind of business including timezone support. Heavily based on: https://gist.github.com/pleax/e9c0da1a6e92dd12cbc7 }
  gem.homepage      = "https://github.com/alberthild/opening_hours"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency "activesupport"
end
