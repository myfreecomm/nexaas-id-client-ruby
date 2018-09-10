# nexaas-id-client-ruby

This is the official Ruby client for the [Nexaas ID](https://id.nexaas.com) API.

[![Gem Version](https://badge.fury.io/rb/nexaas-id-client.png)](https://rubygems.org/gems/nexaas-id-client)
[![Build Status](https://travis-ci.org/myfreecomm/nexaas-id-client-ruby.png?branch=master)](https://travis-ci.org/myfreecomm/nexaas-id-client-ruby)
[![Test Coverage](https://coveralls.io/repos/myfreecomm/nexaas-id-client-ruby/badge.png?branch=master)](https://coveralls.io/r/myfreecomm/nexaas-id-client-ruby)
[![Code Climate Grade](https://codeclimate.com/github/myfreecomm/nexaas-id-client-ruby.png)](https://codeclimate.com/github/myfreecomm/nexaas-id-client-ruby)
[![Inline docs](http://inch-ci.org/github/myfreecomm/nexaas-id-client-ruby.svg)](http://inch-ci.org/github/myfreecomm/nexaas-id-client-ruby)

Nexaas ID API docs: https://id.nexaas.com/static/docs/

nexaas-id-client-ruby RDoc documentation: http://rubydoc.info/github/myfreecomm/nexaas-id-client-ruby/frames/

The [RDoc](http://rubydoc.info/github/myfreecomm/nexaas-id-client-ruby/frames/) is the best place to learn how to use this client. A few example uses are listed below. See the mapping of API endpoints to this client code below as well to find what you need.

This client only uses the API of Nexaas ID. To authenticate users via OAuth2 in Ruby, see the [omni_auth_nexaas_id gem](https://rubygems.org/gems/omni_auth_nexaas_id) ([code](https://github.com/myfreecomm/omniauth-nexaas_id) and [example of use](https://github.com/myfreecomm/nexaas-id-demo-apps)).

## Installation

Add this line to your application's Gemfile:

    gem 'nexaas-id-client', require: 'nexaas_id'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nexaas-id-client

## Support

This gem supports Ruby 2.1 or superior.

## Configuration

### Create a new application

Go to https://id.nexaas.com/applications and create a new application in your Nexaas ID account.

### Use NexaasID.configure to setup your environment

```ruby
require 'nexaas_id'

NexaasID.configure do |c|
  c.url = 'https://sandbox.id.nexaas.com' # defaults to 'https://id.nexaas.com' if omitted
  c.user_agent = 'My App v1.0' # optional, but you should pass a custom user-agent identifying your app
  c.application_token = 'your-application-token'
  c.application_secret = 'your-application-secret'
end
```

## Usage

The API can be used to access resources owned by an `Identity`, which requires previous authorization from the
corresponding user (see the {omni_auth_nexaas_id gem}[https://rubygems.org/gems/omni_auth_nexaas_id]),
or resources owned by an `Application`, which only requires the application's credentials.

### Resources owned by an Identity

#### Create an instance of NexaasID::Client::Identity, as below:

```ruby
client = NexaasID::Client::Identity.new(user_credentials)
```

Here, `user_crendentials` is an object that must have the following attributes available for reading/writing:
* access_token
* refresh_token
* expires_in
* expires_at

As long as these attributes are available, your object can be of any class (an `Active Record` object or a
simple `OpenStruct`, for instance); the client won't make any assumptions about its nature. Your application is responsible
for obtaining the initial values for these attributes (through the OAuth2 Authorization Flow, using the
{omni_auth_nexaas_id gem}[https://rubygems.org/gems/omni_auth_nexaas_id]) and storing them as appropriate
(you might store them using a Users table for instance, or even in your user's session). The client WILL updated these
attributes if the token has to be refreshed (Nexaas ID uses a TTL of 2 hours for access tokens) and your application
needs to update its storage when that happens.

#### Now you have access to the following endpoints:

* [Profile API](TODO: doc link) as `client.profile`
* [SignUp API](TODO: doc link) as `client.signup`
* [Widget API](TODO: doc link) as `client.widget`

#### Examples

```ruby
client = NexaasID::Client::Identity.new(user_credentials)

profile_resource = client.profile

profile = profile_resource.get # Obtains user's profile
profile.id      # '57bb5938-d0c5-439a-9986-e5c565124beb'
profile.email   # 'john.doe@example.com'
profile.name    # 'John Doe'

contacts = profile_resource.professional_info # Obtains user's professional information
contacts.id             # '57bb5938-d0c5-439a-9986-e5c565124beb'
contacts.phone_numbers  # ['+55 21 12345678']

sign_up_resource = client.sign_up

# Invites another user to Nexaas ID on behalf of the current user
sign_up = sign_up_resource.create('another.john@example.com')
sign_up.id        # '1061a775-b86c-4082-b801-767f651fa4c7'
sign_up.email     # 'another.john@example.com'
sign_up.requester # '57bb5938-d0c5-439a-9986-e5c565124beb'

widget_resource = client.widget

# Obtains navigation bar URL with current user information and logout button
navbar_url = widget_resource.navbar_url
```

### Resources not owned by an Identity

#### Create an instance of NexaasID::Client::Application, as below:

```ruby
client = NexaasID::Client::Application.new
```

#### Now you have access to the following endpoints:

* [SignUp API](TODO: doc link) as `client.signup`

#### Examples

```ruby
client = NexaasID::Client::Application.new

sign_up_resource = client.sign_up

# Invites another user to Nexaas ID on behalf of the application
sign_up = sign_up_resource.create('another.john@example.com')
sign_up.id        # '1061a775-b86c-4082-b801-767f651fa4c7'
sign_up.email     # 'another.john@example.com'
sign_up.requester # nil
```

### Error handling

In case of a transport or OAuth error, an instance of NexaasID::Client::Exception will be raised by the client.
This exception can be inspected using the methods `status`, `headers` and `body`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
