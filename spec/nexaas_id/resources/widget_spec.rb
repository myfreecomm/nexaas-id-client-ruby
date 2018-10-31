require 'spec_helper'

describe NexaasID::Resources::Widget do
  let(:client) do
    NexaasID::Client::Identity.new(
      user_credentials(configuration),
      configuration
    )
  end
  let(:configuration) { default_configuration }
  let(:resource) { client.widget }

  describe '#navbar_url' do
    subject { resource.navbar_url }
    let(:regexp) { %r(#{Regexp.quote(configuration.url)}/api/v1/widgets/navbar\?access_token=(.+?)$) }

    it 'returns the navbar url for this user' do
      VCR.use_cassette('identity/widget/navbar_url/success') do
        expect(subject).to match(regexp)
        expect(Faraday.get(subject).status).to eq(200)
      end
    end
  end

  describe '#widget_url' do
    subject { resource.widget_url }
    let(:regexp) { %r(#{Regexp.quote(configuration.url)}/api/v1/widgets/user.js\?access_token=(.+?)&callback=initWidget$) }

    it 'returns the navbar url for this user' do
      VCR.use_cassette('identity/widget/widget_url/success') do
        expect(subject).to match(regexp)
        expect(Faraday.get(subject).status).to eq(200)
      end
    end
  end
end
