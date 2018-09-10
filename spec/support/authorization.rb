require 'faraday-cookie_jar'

module Authorization

  def authorization_code
    connection = Faraday.new(url: NexaasID.configuration.url) do |builder|
      builder.use :cookie_jar
      builder.adapter Faraday.default_adapter
    end

    response = connection.get('/sign_in')
    data = {
      'session[email]': ENV['USER_NAME'],
      'session[password]': ENV['USER_PASSWORD'],
      'authenticity_token': authenticity_token(response)
    }

    connection.post('/sign_in', URI.encode_www_form(data))

    response = connection.get('oauth/authorize',
                              client_id: NexaasID.configuration.application_token,
                              redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
                              response_type: 'code',
                              scope: 'profile invite')

    if(response.headers['location'].nil? || response.headers['location'] == '')
      data = {
        client_id: NexaasID.configuration.application_token,
        commit: 'Authorize',
        redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
        response_type: 'code',
        authenticity_token: authenticity_token(response),
        scope: 'profile invite'
      }

      response = connection.post('/oauth/authorize', URI.encode_www_form(data))
    end

    response.headers['location'].match(%r{code=(.+?)$}).captures.first
  end

  def authenticity_token(response)
    response.body.match(%r{name="authenticity_token" value="(.+?)"}).captures.first
  end

  def access_token
    VCR.use_cassette('access_token') do
      client = NexaasID::Client::OAuth.build
      client.auth_code.get_token(authorization_code, redirect_uri: 'urn:ietf:wg:oauth:2.0:oob')
    end
  end

  def user_credentials
    OpenStruct.new.tap do |credentials|
      token = access_token
      credentials.access_token = token.token
      credentials.refresh_token = token.refresh_token
      credentials.expires_in = token.expires_in
      credentials.expires_at = token.expires_at
    end
  end
end
