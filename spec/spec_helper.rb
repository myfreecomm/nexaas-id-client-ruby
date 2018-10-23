require 'simplecov'
require 'coveralls'
require 'dotenv'

Dotenv.load('.env.test')

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nexaas_id'

require 'vcr'
require 'pry'
require 'webmock/rspec'
require 'support/authorization'
require 'support/configuration_helper'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.default_cassette_options = { record: :new_episodes }
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.example_status_persistence_file_path = '.rspec_persistence'
  c.include Authorization
  c.include ConfigurationHelper

  c.before do
    NexaasID.configure do |config|
      config.url = ENV['NEXAAS_ID_URL']
      config.application_token  = ENV['APPLICATION_TOKEN']
      config.application_secret = ENV['APPLICATION_SECRET']
    end
  end
end
