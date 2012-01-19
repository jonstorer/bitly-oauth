$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'oauth2'
require 'cgi'
require 'forwardable'

module BitlyOAuth
  def self.new(*args)
    BitlyOAuth::Client.new(*args)
  end
end

require 'bitly_oauth/access_token'
require 'bitly_oauth/client'
require 'bitly_oauth/country'
require 'bitly_oauth/day'
require 'bitly_oauth/error'
require 'bitly_oauth/missing_url'
require 'bitly_oauth/realtime_link'
require 'bitly_oauth/referring_domain'
require 'bitly_oauth/referrer'
require 'bitly_oauth/response'
require 'bitly_oauth/url'
require 'bitly_oauth/user'

require 'bitly_oauth/lib/core_ext/hash'
require 'bitly_oauth/lib/core_ext/string'
