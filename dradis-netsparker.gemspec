$:.push File.expand_path('../lib', __FILE__)
require 'dradis/plugins/netsparker/version'
version = Dradis::Plugins::Netsparker::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = 'dradis-netsparker'
  spec.version = version
  spec.summary = 'Netsparker add-on for the Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse output produced from Netsparker Web Vulnerability Scanner into Dradis.'

  spec.license = 'GPL-2'

  spec.authors = ['Daniel Martin']
  spec.homepage = 'https://dradis.com/integrations/netsparker.html'

  spec.files = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

  # By not including Rails as a dependency, we can use the gem with different
  # versions of Rails (a sure recipe for disaster, I'm sure), which is needed
  # until we bump Dradis Pro to 4.1.
  # s.add_dependency 'rails', '~> 4.1.1'
  spec.add_dependency 'dradis-plugins', '~> 4.0'
  spec.add_dependency 'nokogiri', '>= 1.12.5'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
end
