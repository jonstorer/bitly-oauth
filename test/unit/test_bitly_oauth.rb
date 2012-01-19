require 'test_helper'

class TestBitlyOAuth < Test::Unit::TestCase
  context "bitly oauth module" do
    context "with a client id and client secret" do
      should "create a new client" do
        client = BitlyOAuth.new("client_id", "client_secret")
        assert client.is_a?(BitlyOAuth::Client)
      end
    end
    context "with bad information" do
      should "raise an error" do
        assert_raise ArgumentError do
          BitlyOAuth.new
        end
      end
    end
  end
end
