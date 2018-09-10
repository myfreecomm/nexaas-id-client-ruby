# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','nexaas_id','version.rb'])

Gem::Specification.new do |spec|
  spec.name          = "nexaas-id-client"
  spec.version       = NexaasID::VERSION
  spec.authors       = ["Rodrigo Tassinari de Oliveira", "Eduardo Hertz", "Rafael B. Tauil", "Luiz Carlos Buiatte"]
  spec.email         = ["rodrigo@pittlandia.net", "rodrigo.tassinari@myfreecomm.com.br", "eduardo.hertz@myfreecomm.com.br", "rafael@tauil.com.br", "luiz.buiatte@nexaas.com"]
  spec.description   = %q{A Ruby client for the Nexaas ID REST API}
  spec.summary       = %q{A Ruby client for the Nexaas ID REST API: https://id.nexaas.com/static/docs/}
  spec.homepage      = "https://github.com/myfreecomm/nexaas-id-client-ruby"
  spec.license       = "Apache-2.0"
  spec.has_rdoc      = true

  # VCR cassettes are too long for the gemspec, see http://stackoverflow.com/questions/14371686/building-rails-3-engine-throwing-gempackagetoolongfilename-error
  # spec.files         = `git ls-files`.split($/)
  spec.files         = `git ls-files`.split($/).reject { |f| f =~ %r{(vcr_cassettes)/} }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json", "~> 1.11"
  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "oauth2", "~> 1.4.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rdoc", "~> 6.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "vcr", "~> 2.4"
  spec.add_development_dependency 'webmock', '~> 3.4'
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "awesome_print", "~> 1.8"
  spec.add_development_dependency "simplecov", "~> 0.14"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "json", "~> 2.1"
  spec.add_development_dependency "faraday-cookie_jar", "~> 0.0.6"
  spec.add_development_dependency "dotenv", "~> 2.5.0"
end
