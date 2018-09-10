# A wrapper to Nexaas ID's widget API
#
# [API]
#   Documentation:
#
# @example Obtaining the user's navbar URL:
#   client = NexaasID::Client::Identity.new(credentials)
#   client.widget.navbar_url
#
# @example Inviting a new user to Nexaas ID (on behalf of an application):
#   client = NexaasID::Client::Application.new
#   client.sign_up.create('john.doe@gmail.com')
#
# @see NexaasID::Client::Identity#initialize
class NexaasID::Resources::Widget < NexaasID::Resources::Base

  # Retrieves the user's navbar URL
  #
  # [API]
  #   Method: <tt>GET /api/v1/widgets/navbar</tt>
  #
  #   Documentation:
  #
  # @return [String] user's navbar URL
  def navbar_url
    %(#{NexaasID.configuration.url}/api/v1/widgets/navbar?access_token=#{api.token})
  end
end
