require 'test_helper'

class TestUser < Test::Unit::TestCase
  context "with an access_token" do
    setup do
      client       = BitlyOAuth::Client.new('client_id', 'client_secret')
      access_token = client.get_access_token_from_token('token')
      @user        = BitlyOAuth::User.new(access_token)
    end

    context 'the user' do
      should 'get a client' do
        assert_kind_of BitlyOAuth::Client, @user.client
      end
    end
  end
end
