require 'spec_helper'

describe NexaasID::Resources::Profile do
  let(:client) { NexaasID::Client::Identity.new(user_credentials) }
  let(:resource) { client.profile }

  describe "#get" do
    subject { resource.get }

    it 'returns the profile for the user' do
      VCR.use_cassette('identity/profile/profile/success') do
        expect(subject).to be_a(NexaasID::Entities::Profile)
        expect(subject.id).to eq('57bb5938-d0c5-439a-9986-e5c565124beb')
        expect(subject.email).to eq('luiz.buiatte+pw.api.test@nexaas.com')
      end
    end
  end

  describe '#profession_info' do
    subject { resource.professional_info }

    it 'returns the professional info for the user' do
      VCR.use_cassette('identity/profile/professional_info/success') do
        expect(subject).to be_a(NexaasID::Entities::Profile::ProfessionalInfo)
        expect(subject.id).to eq('57bb5938-d0c5-439a-9986-e5c565124beb')
        expect(subject.company).to eq('Nexaas')
      end
    end
  end

  describe '#contacts' do
    subject { resource.contacts }

    it 'returns the contacts for the user' do
      VCR.use_cassette('identity/profile/contacts/success') do
        expect(subject).to be_a(NexaasID::Entities::Profile::Contacts)
        expect(subject.id).to eq('57bb5938-d0c5-439a-9986-e5c565124beb')
        expect(subject.phone_numbers).not_to be_empty
      end
    end
  end

  describe '#contacts' do
    subject { resource.emails }

    it 'returns the contacts for the user' do
      VCR.use_cassette('identity/profile/emails/success') do
        expect(subject).to be_a(NexaasID::Entities::Profile::Emails)
        expect(subject.id).to eq('57bb5938-d0c5-439a-9986-e5c565124beb')
        expect(subject.emails).not_to be_empty
      end
    end
  end
end
