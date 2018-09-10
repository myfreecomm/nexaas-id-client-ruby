# Nexaas ID Client for resources owned by an Identity
#
# [API]
#   Documentation:
#
# @example Obtaining a user's profile:
#   client = NexaasID::Client::Identity.new(user_credentials)
#   client.profile.get
#
class NexaasID::Client::Identity
  # Creates an instance of this client.
  #
  # @param [
  #   #access_token, #access_token=,
  #   #refresh_token, #refresh_token=,
  #   #expires_at, #expires_at=
  #   #expires_in, #expires_in=] The user credentials, obtained through the OAuth2 authorization flow.
  def initialize(credentials)
    @credentials = credentials
    @token = NexaasID::Client::ExceptionWrapper.new(OAuth2::AccessToken.from_hash(client, hash))
  end

  # Provides a Profile resource.
  # @return [NexaasID::Resources::Profile] the profile resource.
  def profile
    NexaasID::Resources::Profile.new(api)
  end

  # Provides a SignUp resource.
  # @return [NexaasID::Resources::SignUp] the signup resource.
  def sign_up
    NexaasID::Resources::SignUp.new(api)
  end

  # Provides a Widget resource.
  # @return [NexaasID::Resources::Widget] the widget resource.
  def widget
    NexaasID::Resources::Widget.new(api)
  end

  private

  attr_reader :credentials
  attr_accessor :token

  ATTRIBUTES = %i[access_token refresh_token expires_at expires_in].freeze

  def api
    token.expired? ? refresh_token : token
  end

  def client
    @client ||= NexaasID::Client::OAuth.build
  end

  def hash
    ATTRIBUTES.map { |attr| [attr, credentials.send(attr)] }.to_h
  end

  def refresh_token
    token.refresh!.tap do |token|
      self.token = NexaasID::Client::ExceptionWrapper.new(token)
      credentials.access_token = token.token
      (ATTRIBUTES - [:access_token]).each { |attr| credentials.send("#{attr}=", token.send(attr)) }
    end
  end
end
