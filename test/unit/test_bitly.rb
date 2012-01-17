require 'test_helper'

class TestBitlyr < Test::Unit::TestCase
  context "bitlyr module" do
    context "with a login and api key" do
      should "create a new bitlyr client" do
        bitlyr = Bitlyr.new(:login => "login", :api_key => "api key")
        assert bitlyr.is_a?(Bitlyr::Client)
      end
      should "create have a ApiKey Strategy" do
        strategy = Bitlyr.new(:login => "login", :api_key => "api key").send(:strategy)
        assert strategy.is_a?(Bitlyr::Strategy::ApiKey)
      end
    end
    context "with a client id and client secret" do
      should "create a new bitlyr client" do
        bitlyr = Bitlyr.new(:client_id => "client id", :client_secret => "client secret")
        assert bitlyr.is_a?(Bitlyr::Client)
      end
      should "create have a OAuth Strategy" do
        strategy = Bitlyr.new(:client_id => "client id", :client_secret => "client secret").send(:strategy)
        assert strategy.is_a?(Bitlyr::Strategy::OAuth)
      end
      should "not create an access token for the client" do
        strategy = Bitlyr.new(:client_id => "client id", :client_secret => "client secret").send(:strategy)
        assert_equal nil, strategy.send(:access_token)
      end
    end
    context "with a client id, client secret and token" do
      should "create a new bitlyr client" do
        bitlyr = Bitlyr.new(:client_id => "client id", :client_secret => "client secret", :token => "token")
        assert bitlyr.is_a?(Bitlyr::Client)
      end
      should "create have a OAuth Strategy" do
        strategy = Bitlyr.new(:client_id => "client id", :client_secret => "client secret", :token => "token").send(:strategy)
        assert strategy.is_a?(Bitlyr::Strategy::OAuth)
      end
      should "create have a bitlyr access token" do
        strategy = Bitlyr.new(:client_id => "client id", :client_secret => "client secret", :token => "token").send(:strategy)
        assert strategy.send(:access_token).is_a?(Bitlyr::Strategy::AccessToken)
      end
    end
    context "with bad information" do
      should "raise an error" do
        assert_raise RuntimeError do
          Bitlyr.new({})
        end
      end
    end
  end
end
