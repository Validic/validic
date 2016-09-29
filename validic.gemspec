lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validic/version'

Gem::Specification.new do |spec|
  spec.name          = "validic"
  spec.version       = Validic::VERSION
  spec.authors       = ["Julius Francisco & Jay Balanay"]
  spec.email         = ["julius@validic.com", "jay@validic.com"]
  spec.description   = %q{API Wrapper for Validic}
  spec.summary       = spec.description
  spec.homepage      = "https://validic.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday_middleware', '~> 0.10'
  spec.add_dependency 'multi_json'
  spec.add_development_dependency "bundler"
end
