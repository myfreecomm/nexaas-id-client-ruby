require 'addressable/uri'

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
  def navbar_url(redirect_uri = nil)
    access_token = api.token
    querystring =
      if access_token
        {access_token: access_token}
      elseif redirect_uri
        {
          client_id: configuration.application_token,
          redirect_uri: redirect_uri
        }
      else
        nil
      end
    uri = Addressable::URI.parse(configuration.url)
    uri.path = '/api/v1/widgets/navbar'
    uri.query_values = querystring
    uri.to_s
  end

  # Retrieves the user's widget URL
  #
  # [API]
  #   Method: <tt>GET /api/v1/widgets/user</tt>
  #
  #   Documentation:
  #
  # @return [String] user's widget URL
  def widget_url(callback = 'initWidget')
    %(#{configuration.url}/api/v1/widgets/user.js?access_token=#{api.token}&callback=#{callback})
  end
end
