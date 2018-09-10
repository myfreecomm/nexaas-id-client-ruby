# encoding: utf-8
require 'spec_helper'

describe NexaasID::Configuration do

  it "should use the production Nexaas ID URL by default" do
    expect(NexaasID::Configuration.new.url).to eq('https://id.nexaas.com')
  end

  it "should use a default user agent" do
    expect(NexaasID::Configuration.new.user_agent).to eq("Nexaas ID Ruby Client v#{NexaasID::VERSION}")
  end

  it 'should allow setting the configuration parameters' do
    config = NexaasID::Configuration.new

    config.url = 'https://sandbox.id.nexaas.com'
    config.application_token = '58ca7acc-9479-4671-8b7c-745c5a65ce08'
    config.application_secret = '8da0d1a5-961d-461f-8ae6-1922db172340'

    expect(config.url).to eq('https://sandbox.id.nexaas.com')
    expect(config.application_token).to eq('58ca7acc-9479-4671-8b7c-745c5a65ce08')
    expect(config.application_secret).to eq('8da0d1a5-961d-461f-8ae6-1922db172340')
  end

  describe '#url_for' do
    let(:configuration) { described_class.new }

    it 'generates an URL to a resource' do
      expect(configuration.url_for('/api/v1/profile')).to eq('https://id.nexaas.com/api/v1/profile')

      configuration.url = 'https://sandbox.id.nexaas.com/'
      expect(configuration.url_for('/api/v1/profile'))
        .to eq('https://sandbox.id.nexaas.com/api/v1/profile')
    end
  end

end
