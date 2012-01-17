$:.unshift File.dirname(__FILE__)

require 'httparty'
require 'oauth2'
require 'cgi'
require 'forwardable'

module Bitlyr
  def self.new(params = {})
    params.symbolize_keys!
    if params.key?(:client_id) && params.key?(:client_secret)
      strategy = Bitlyr::Strategy::OAuth.new(params[:client_id], params[:client_secret])
      strategy.set_access_token_from_token!(params[:token]) if params[:token]
      Bitlyr::Client.new strategy
    elsif params.key?(:login) && params.key?(:api_key)
      Bitlyr::Client.new Bitlyr::Strategy::ApiKey.new(params[:login], params[:api_key])
    else
      raise "requires a login and apiKey or client id and client secret"
    end
  end
end

require 'bitlyr/client'
require 'bitlyr/country'
require 'bitlyr/day'
require 'bitlyr/error'
require 'bitlyr/missing_url'
require 'bitlyr/realtime_link'
require 'bitlyr/referrer'
require 'bitlyr/response'
require 'bitlyr/url'
require 'bitlyr/user'
require 'bitlyr/strategy/base'
require 'bitlyr/strategy/access_token'
require 'bitlyr/strategy/api_key'
require 'bitlyr/strategy/oauth'

require 'bitlyr/lib/core_ext/hash'
require 'bitlyr/lib/core_ext/string'
