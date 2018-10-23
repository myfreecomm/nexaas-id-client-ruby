# encoding: utf-8
require 'spec_helper'

describe NexaasID do
  it 'should have a version number' do
    expect(NexaasID::VERSION).not_to be_nil
  end

  describe 'default configuration' do
    it 'should be done via block initialization' do
      NexaasID.configure do |c|
        c.url = 'http://some/where'
        c.user_agent = 'My App v1.0'
        c.application_token = 'some-app-token'
        c.application_secret = 'some-app-secret'
      end

      config = NexaasID.default_configuration
      expect(config.url).to eq('http://some/where')
      expect(config.user_agent).to eq('My App v1.0')
      expect(config.application_token).to eq('some-app-token')
      expect(config.application_secret).to eq('some-app-secret')
    end

    it 'should use a singleton object for the configuration values' do
      config1 = NexaasID.default_configuration
      config2 = NexaasID.default_configuration
      expect(config1).to be === config2
    end
  end
end
