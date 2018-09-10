require 'spec_helper'

describe NexaasID::Resources::Widget do
  let(:client) { NexaasID::Client::Identity.new(user_credentials) }
  let(:resource) { client.widget }

  describe "#navbar_url" do
    subject { resource.navbar_url }
    let(:regexp) { %r(#{Regexp.quote(NexaasID.configuration.url)}/api/v1/widgets/navbar\?access_token=(.+?)$) }

    it 'returns the navbar url for this user' do
      VCR.use_cassette('identity/widget/navbar_url/success') do
        expect(subject).to match(regexp)
        expect(Faraday.get(subject).status).to eq(200)
      end
    end
  end
end
