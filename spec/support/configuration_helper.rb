module ConfigurationHelper
  def default_configuration
    NexaasID::Configuration.build do |config|
      # https://sandbox.id.nexaas.com/applications/89e9d504-e2a8-476e-ac94-c33e68399c7e
      # Test application - luiz.buiatte+pw.api.test@nexaas.com
      config.url = ENV['NEXAAS_ID_URL']
      config.application_token = ENV['APPLICATION_TOKEN']
      config.application_secret = ENV['APPLICATION_SECRET']
    end
  end
end
