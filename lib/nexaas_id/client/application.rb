require_relative './base'

# Nexaas ID Client for resources not owned by an Identity
#
# [API]
#   Documentation:
#
# @example Inviting a new user:
#   client = NexaasID::Client::Application.new
#   client.sign_up.create(invited: 'john.doe@example.com')
#
class NexaasID::Client::Application < NexaasID::Client::Base
  def initialize(config = nil)
    super(config)
    @tokens = {}
  end

  protected

  def api_token
    token(:invite)
  end

  private

  attr_reader :tokens

  def token(scope = nil)
    token = tokens[scope]
    return token unless token.nil? || token.expired?
    tokens[scope] = NexaasID::Client::ExceptionWrapper.new(client.client_credentials.get_token(scope: scope))
  end
end
