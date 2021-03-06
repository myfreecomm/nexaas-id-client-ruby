require 'spec_helper'

describe NexaasID::Client::Application do
  describe 'implicit default configuration' do
    subject { described_class.new }

    describe '#sign_up' do
      it 'provides the signup resource' do
        VCR.use_cassette('application/sign_up/client_credentials') do
          expect(subject.sign_up).to be_a(NexaasID::Resources::SignUp)
        end
      end
    end
  end

  describe 'explicit configuration' do
    subject { described_class.new(configuration) }

    let(:configuration) { default_configuration }

    describe '#sign_up' do
      it 'provides the signup resource' do
        VCR.use_cassette('application/sign_up/client_credentials') do
          expect(subject.sign_up).to be_a(NexaasID::Resources::SignUp)
        end
      end
    end
  end
end
