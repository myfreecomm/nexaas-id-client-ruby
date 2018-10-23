class NexaasID::Client::Base
  def initialize(config = nil)
    @config = config || NexaasID.default_configuration
  end

  # Provides a SignUp resource.
  # @return [NexaasID::Resources::SignUp] the signup resource.
  def sign_up
    NexaasID::Resources::SignUp.new(api_token, config)
  end

  protected

  attr_accessor :config

  def api_token
    raise NotImplementedError
  end

  def client
    @client ||= NexaasID::Client::OAuth.new(config)
  end
end
