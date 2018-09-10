# A wrapper to Nexaas ID's sign up API
#
# [API]
#   Documentation:
#
# @example Inviting a new user to Nexaas ID (on behalf of an existing user):
#   client = NexaasID::Client::Identity.new(credentials)
#   client.sign_up.create('john.doe@gmail.com')
#
# @example Inviting a new user to Nexaas ID (on behalf of an application):
#   client = NexaasID::Client::Application.new
#   client.sign_up.create('john.doe@gmail.com')
#
# @see NexaasID::Client::Identity#initialize
# @see NexaasID::Client::Application#initialize
class NexaasID::Resources::SignUp < NexaasID::Resources::Base

  # Invites an user to Nexaas ID, by creating a new sign up.
  #
  # [API]
  #   Method: <tt>POST /api/v1/sign_up</tt>
  #
  #   Documentation:
  # @param [String] email The new user's email.
  #
  # @return [NexaasID::Entities::SignUp] the new sign up; it contains the invited user's id.
  def create(email)
    respond_with_entity(api.post('/api/v1/sign_up', body: MultiJson.dump({ invited: email })))
  end
end
