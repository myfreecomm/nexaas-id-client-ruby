# encoding: utf-8

require 'oauth2'
require 'multi_json'

require "nexaas_id/version"
require "nexaas_id/configuration"

require "nexaas_id/client"
require "nexaas_id/client/application"
require "nexaas_id/client/exception"
require "nexaas_id/client/exception_wrapper"
require "nexaas_id/client/identity"
require "nexaas_id/client/oauth"

require "nexaas_id/entities"
require "nexaas_id/entities/base"

require "nexaas_id/entities/profile"
require "nexaas_id/entities/profile/professional_info"
require "nexaas_id/entities/profile/contacts"
require "nexaas_id/entities/profile/emails"

require "nexaas_id/entities/sign_up"

require "nexaas_id/resources"
require "nexaas_id/resources/base"
require "nexaas_id/resources/profile"
require "nexaas_id/resources/sign_up"
require "nexaas_id/resources/widget"

module NexaasID
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end
