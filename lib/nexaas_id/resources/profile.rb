# A wrapper to Nexaas ID's profile API
#
# [API]
#   Documentation:
#
# @example Getting the user's profile:
#   client = NexaasID::Client::Identity.new(credentials)
#   client.profile.get
#
# @example Getting the user's list of emails:
#   client = NexaasID::Client::Identity.new(credentials)
#   client.profile.emails
#
# @see NexaasID::Client::Identity#initialize
class NexaasID::Resources::Profile < NexaasID::Resources::Base

  # Retrieves the user's profile
  #
  # [API]
  #   Method: <tt>GET /api/v1/profile</tt>
  #
  #   Documentation:
  #
  # @return [NexaasID::Entities::Profile] user's profile
  def get
    respond_with_entity(api.get('/api/v1/profile'))
  end

  # Retrieves the user's professional info
  #
  # [API]
  #   Method: <tt>GET /api/v1/profile/professional_info</tt>
  #
  #   Documentation:
  #
  # @return [NexaasID::Entities::Profile::ProfessionalInfo] user's professional info
  def professional_info
    respond_with_entity(api.get('/api/v1/profile/professional_info'),
                        NexaasID::Entities::Profile::ProfessionalInfo)
  end

  # Retrieves the user's contacts
  #
  # [API]
  #   Method: <tt>GET /api/v1/profile/contacts</tt>
  #
  #   Documentation:
  #
  # @return [NexaasID::Entities::Profile::Contacts] user's contacts
  def contacts
    respond_with_entity(api.get('/api/v1/profile/contacts'),
                        NexaasID::Entities::Profile::Contacts)
  end

  # Retrieves the user's emails
  #
  # [API]
  #   Method: <tt>GET /api/v1/profile/emails</tt>
  #
  #   Documentation:
  #
  # @return [NexaasID::Entities::Profile::Emails] user's emails
  def emails
    respond_with_entity(api.get('/api/v1/profile/emails'),
                        NexaasID::Entities::Profile::Emails)
  end
end
