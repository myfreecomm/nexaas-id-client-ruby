require 'spec_helper'

describe NexaasID::Client::ExceptionWrapper do
  let(:token) { instance_double('OAuth::AccessToken') }
  subject { described_class.new(token) }

  let(:oauth2_error) { OAuth2::Error.new(response) }
  let(:faraday_error) { Faraday::ClientError.new(Faraday::Error::ConnectionFailed.new('timeout')) }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { { text: 'Coffee brewing failed' }.to_json }
  let(:response) do
    OAuth2::Response.new(double('response', status: 418, headers: headers, body: body))
  end

  describe '#request' do
    it 'delegates to token' do
      expect(token).to receive(:request).with(:get, '/api/v1/profile')
      subject.request(:get, '/api/v1/profile')
    end

    it 'should raise an exception for Faraday::ClientError' do
      expect(token).to receive(:request).with(:get, '/api/v1/profile').and_raise(faraday_error)
      expect { subject.request(:get, '/api/v1/profile') }.to raise_error(NexaasID::Client::Exception)
    end

    it 'should raise an exception for Faraday::ClientError' do
      expect(token).to receive(:request).with(:get, '/api/v1/profile').and_raise(oauth2_error)
      expect { subject.request(:get, '/api/v1/profile') }.to raise_error(NexaasID::Client::Exception)
    end
  end

  describe '#refresh' do
    it 'delegates to token' do
      expect(token).to receive(:refresh).with(a: :b)
      subject.refresh(a: :b)
    end

    it 'should raise an exception for Faraday::ClientError' do
      expect(token).to receive(:refresh).with(a: :b).and_raise(faraday_error)
      expect { subject.refresh(a: :b) }.to raise_error(NexaasID::Client::Exception)
    end

    it 'should raise an exception for Faraday::ClientError' do
      expect(token).to receive(:refresh).with(a: :b).and_raise(oauth2_error)
      expect { subject.refresh(a: :b) }.to raise_error(NexaasID::Client::Exception)
    end
  end
end
