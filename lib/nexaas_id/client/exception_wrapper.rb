# Delegator class which intercepts exceptions raised by OAuth::AccessToken methods
# and wraps them in [NexaasID::Client::Exception] exceptions.
#
# [API]
#   Documentation:
#
class NexaasID::Client::ExceptionWrapper < SimpleDelegator
  def refresh(*args)
    call_with_rescue { super }
  end

  def request(*args, &block)
    call_with_rescue { super }
  end

  private

  def call_with_rescue
    yield
  rescue Faraday::ClientError, OAuth2::Error => exception
    raise NexaasID::Client::Exception.new(exception.message, exception.response)
  end
end
