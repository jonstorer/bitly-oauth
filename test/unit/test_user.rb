require 'test_helper'

class TestUser < Test::Unit::TestCase
  context "with an access_token" do
    setup do
      @user = BitlyOAuth::User.new('token')
    end

    context 'the user' do
      should 'get a client' do
        assert_kind_of BitlyOAuth::Client, @user.client
      end
    end
  end
end
