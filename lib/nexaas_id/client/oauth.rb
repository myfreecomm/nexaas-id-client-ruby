require 'oauth2'

# OAuth2 client used by NexaasID::Client::Application and NexaasID::Client::Identity.
# Provides direct access to the underlying OAuth2 API.
class NexaasID::Client::OAuth

  def self.build
    config = NexaasID.configuration
    OAuth2::Client.new(config.application_token,
                       config.application_secret,
                       site: config.url,
                       connection_opts: { headers: headers })
  end

  private

  def self.headers
    { 'Accept': 'application/json', 'Content-type': 'application/json' }
  end
end
