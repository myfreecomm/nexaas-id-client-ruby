# Nexaas ID Client for resources not owned by an Identity
#
# [API]
#   Documentation:
#
# @example Inviting a new user:
#   client = NexaasID::Client::Application.new
#   client.sign_up.create(invited: 'john.doe@example.com')
#
class NexaasID::Client::Application

  def initialize
    @tokens = {}
  end

  # Provides a SignUp resource.
  # @return [NexaasID::Resources::SignUp] the signup resource.
  def sign_up
    NexaasID::Resources::SignUp.new(token(:invite))
  end

  private

  attr_reader :tokens, :credentials

  def client
    @client ||= NexaasID::Client::OAuth.build
  end

  def token(scope = nil)
    token = tokens[scope]
    return token unless token.nil? || token.expired?
    tokens[scope] = NexaasID::Client::ExceptionWrapper.new(client.client_credentials.get_token(scope: scope))
  end
end
