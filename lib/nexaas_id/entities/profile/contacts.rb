class NexaasID::Entities::Profile::Contacts < NexaasID::Entities::Base
  attribute :id,            Integer
  attribute :phone_numbers, Array[String]
end
