class NexaasID::Entities::Profile < NexaasID::Entities::Base
  attribute :id,        Integer
  attribute :name,      String
  attribute :nickname,  String
  attribute :email,     String
  attribute :birth,     Date
  attribute :gender,    String
  attribute :language,  String
  attribute :picture,   String
  attribute :timezone,  String
  attribute :country,   String
  attribute :city,      String
  attribute :bio,       String
end
