require 'spec_helper'

describe NexaasID::Client::Exception do
  subject { described_class.new('foobar', response) }

  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { { text: 'Coffee brewing failed' }.to_json }
  let(:response) do
    OAuth2::Response.new(double('response', status: 418, headers: headers, body: body))
  end

  it { expect(subject.status).to eq(418) }
  it { expect(subject.headers).to eq(headers) }
  it { expect(subject.body).to eq(body) }
end
