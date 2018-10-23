class NexaasID::Configuration

  attr_accessor :url, :user_agent, :application_token, :application_secret

  def self.configure
    config = new
    yield(config) if block_given?
    config
  end

  def initialize
    @url = 'https://id.nexaas.com'
    @user_agent = "Nexaas ID Ruby Client v#{NexaasID::VERSION}"
  end

  def url_for(path)
    %(#{url.chomp('/')}#{path})
  end
end
