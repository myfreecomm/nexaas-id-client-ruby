class NexaasID::Entities::Profile::Emails < NexaasID::Entities::Base
  attribute :id,      Integer
  attribute :emails,  Array[String]
end
