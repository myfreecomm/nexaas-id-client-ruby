# encoding: utf-8
require 'spec_helper'

describe NexaasID::Configuration do
  subject do
    described_class.configure do |c|
      c.url = 'http://some/where'
      c.user_agent = 'My App v1.0'
      c.application_token = 'some-app-token'
      c.application_secret = 'some-app-secret'
    end
  end

  it "should use the production Nexaas ID URL by default" do
    expect(subject.url).to eq('http://some/where')
  end

  it "should use a default user agent" do
    expect(subject.user_agent).to eq('My App v1.0')
  end

  it 'generates an URL to a resource' do
    configuration = subject

    expect(configuration.url_for('/api/v1/profile')).
      to eq('http://some/where/api/v1/profile')

    configuration.url = 'https://sandbox.id.nexaas.com/'
    expect(configuration.url_for('/api/v1/profile'))
      .to eq('https://sandbox.id.nexaas.com/api/v1/profile')
  end
end
