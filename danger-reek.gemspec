# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reek/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'danger-reek'
  spec.version       = Reek::VERSION
  spec.authors       = ['blooper05']
  spec.email         = ['legend.of.blooper@gmail.com']
  spec.description   = 'A Danger plugin to lint Ruby files through Reek.'
  spec.summary       = 'A Danger plugin to lint Ruby files through Reek.'
  spec.homepage      = 'https://github.com/blooper05/danger-reek'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'
  spec.add_runtime_dependency 'reek', '>= 3.6', '< 7.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '>= 1.3', '< 3'
  spec.add_development_dependency 'rake', '~> 13.0'

  # Testing support
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.13'

  # Linting code and docs
  spec.add_development_dependency 'rubocop', '~> 1.4'
  spec.add_development_dependency 'yard'

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  # If you want to work on older builds of ruby
  spec.add_development_dependency 'listen', '= 3.2.1'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry'

  # Release support
  spec.add_development_dependency 'github_changelog_generator'
end
