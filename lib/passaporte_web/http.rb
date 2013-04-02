# encoding: utf-8
module PassaporteWeb

  class Http # :nodoc:

    def self.get(path='/', params={})
      RestClient.get(
        pw_url(path),
        {params: params}.merge(common_params)
      )
    end

    def self.put(path='/', body={}, params={})
      RestClient.put(
        pw_url(path),
        encoded_body(body),
        {params: params}.merge(common_params)
      )
    end

    def self.post(path='/', body={}, params={})
      RestClient.post(
        pw_url(path),
        encoded_body(body),
        {params: params}.merge(common_params)
      )
    end

    def self.delete(path='/', params={})
      RestClient.delete(
        pw_url(path),
        {params: params}.merge(common_params)
      )
    end

    private

    def self.pw_url(path)
      "#{PassaporteWeb.configuration.url}#{path}"
    end

    def self.common_params
      {
        authorization: PassaporteWeb.configuration.application_credentials,
        content_type: :json,
        accept: :json,
        user_agent: PassaporteWeb.configuration.user_agent
      }
    end

    def self.encoded_body(body)
      body.is_a?(Hash) ? MultiJson.encode(body) : body
    end

  end

end
