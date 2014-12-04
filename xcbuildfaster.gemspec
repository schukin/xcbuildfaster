# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xcbuildfaster/version'

Gem::Specification.new do |spec|
  spec.name          = "XCBuildFaster"
  spec.version       = Xcbuildfaster::VERSION
  spec.authors       = ["Dave Schukin"]
  spec.email         = ["daveschukin@gmail.com"]
  spec.summary       = %q{Tweaks your Xcode workspace to make it compile faster.}
  spec.description   = %q{Tweaks your Xcode workspace to make it compile faster.}
  spec.homepage      = "https://github.com/schukin/xcbuildfaster"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['xcbuildfaster'] #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'xcodeproj'
  spec.add_dependency 'libxml-ruby' # faster XML parsing w/ xcodeproj

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
end
