# Default root for all resource classes.
class NexaasID::Resources::Base
  # Creates an instance of this class.
  #
  # @param [api] api An instance of OAuth2::AccessToken
  def initialize(api)
    @api = api
  end

  protected

  attr_reader :api

  # Builds an entity from the OAuth2 response.
  #
  # @param [OAuth2::Response] response The response from any OAuth2::AccessToken method
  # @param [NexaasID::Entities::Base] naked_klass The class which the response will be
  #   deserialized into (must be a subtype of NexaasID::Entities::Base).
  #   Optional if the entity name is the same as the resource name.
  #
  # @return [NexaasID::Entities::Base] an instance of naked_class
  def respond_with_entity(response, naked_klass = entity_klass)
    # response.parsed is a Hash
    naked_klass.new(response.parsed)
  end

  def base_klass
    @base_klass ||= self.class.name.split("::").last
  end

  def entity_klass
    @entity_klass ||= NexaasID::Entities.const_get(base_klass.to_sym)
  end
end
