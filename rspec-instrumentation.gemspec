# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_instrumentation/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-instrumentation'
  spec.version       = RSpecInstrumentation::VERSION
  spec.summary       = 'RSpec instrumentation'
  spec.description   = 'A RSpec instrumentation component'

  spec.required_ruby_version = '>= 2.6.0'

  spec.license  = 'MIT'
  spec.authors  = ['Mattia Roccoberton']
  spec.email    = 'mat@blocknot.es'
  spec.homepage = 'https://github.com/blocknotes/rspec-instrumentation'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rspec', '~> 3.11'
end
