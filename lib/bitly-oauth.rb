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

require 'bitly-oauth/access_token'
require 'bitly-oauth/client'
require 'bitly-oauth/country'
require 'bitly-oauth/day'
require 'bitly-oauth/error'
require 'bitly-oauth/missing_url'
require 'bitly-oauth/realtime_link'
require 'bitly-oauth/referring_domain'
require 'bitly-oauth/referrer'
require 'bitly-oauth/response'
require 'bitly-oauth/url'
require 'bitly-oauth/user'

require 'bitly-oauth/lib/core_ext/hash'
require 'bitly-oauth/lib/core_ext/string'
