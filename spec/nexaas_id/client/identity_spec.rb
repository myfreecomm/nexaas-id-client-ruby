require 'spec_helper'

describe NexaasID::Client::Identity do
  describe 'implicit default configuration' do
    subject do
      described_class.new(user_credentials(NexaasID.default_configuration))
    end

    describe '#profile' do
      it 'provides the profile resource' do
        VCR.use_cassette('identity/refresh_token') do
          expect(subject.profile).to be_a(NexaasID::Resources::Profile)
        end
      end
    end
  end

  describe 'explicit configuration' do
    subject do
      described_class.new(user_credentials(configuration), configuration)
    end

    let(:configuration) { default_configuration }

    describe '#profile' do
      it 'provides the profile resource' do
        VCR.use_cassette('identity/refresh_token') do
          expect(subject.profile).to be_a(NexaasID::Resources::Profile)
        end
      end
    end

    describe '#sign_up' do
      it 'provides the signup resource' do
        VCR.use_cassette('identity/refresh_token') do
          expect(subject.sign_up).to be_a(NexaasID::Resources::SignUp)
        end
      end
    end

    describe '#sign_up' do
      it 'provides the widget resource' do
        VCR.use_cassette('identity/refresh_token') do
          expect(subject.widget).to be_a(NexaasID::Resources::Widget)
        end
      end
    end

    describe '#credentials' do
      it 'returns the updated credentials' do
        expect(subject.credentials).to eq(user_credentials(configuration))
      end
    end
  end
end
