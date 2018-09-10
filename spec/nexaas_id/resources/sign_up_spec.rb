require 'spec_helper'

describe NexaasID::Resources::SignUp do
  let(:resource) { client.sign_up }

  describe "#create" do
    describe 'with application client' do
      let(:client) { NexaasID::Client::Application.new }
      subject { resource.create('demurtas@mailinator.com') }

      it 'invites an user' do
        VCR.use_cassette('application/sign_up/create/success') do
          expect(subject.id).not_to be_nil
          expect(subject.email).to eq('demurtas@mailinator.com')
          expect(subject.requester).to be_nil
        end
      end
    end

    describe 'with identity client' do
      let(:client) { NexaasID::Client::Identity.new(user_credentials) }
      subject { resource.create('demurtas@mailinator.com') }

      it 'invites an user' do
        VCR.use_cassette('identity/sign_up/create/success') do
          expect(subject.id).not_to be_nil
          expect(subject.email).to eq('demurtas@mailinator.com')
          expect(subject.requester).not_to be_nil
        end
      end
    end
  end
end
