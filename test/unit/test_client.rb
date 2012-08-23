require 'test_helper'

class TestClient < Test::Unit::TestCase
  context "creating a new client" do
    should "initialize with clinet id and secret" do
      assert_nothing_raised do
        BitlyOAuth::Client.new('client_id', 'client_secret')
      end
    end
    should "raise an exception when bad arguments are used" do
      assert_raise ArgumentError do
        BitlyOAuth::Client.new("Something Else")
      end
    end
  end
  context "with a new client" do
    setup do
      @client = BitlyOAuth.new('client_id', 'client_secret')
    end
    should 'get the oauth authorize url' do
      redirect_url = 'http://localhost.local/'
      authorize_url = @client.authorize_url(redirect_url)
      assert_match %r{https://bitly.com/oauth/authorize\?.*client_id=client_id.*}, authorize_url
      assert_match %r{https://bitly.com/oauth/authorize\?.*redirect_uri=#{CGI.escape(redirect_url)}.*}, authorize_url
    end
    context "get an access token" do
      setup do
        ::OAuth2::Client.stubs(:new => stub(:auth_code => stub(:get_token => true)))
      end
      should 'return an access token from a code' do
        response = @client.get_access_token_from_code('code', 'redirect_url')
        assert response.is_a?(BitlyOAuth::AccessToken)
      end
      should 'set an access token from a code' do
        response = @client.set_access_token_from_code('code', 'redirect_url')
        assert response.is_a?(BitlyOAuth::AccessToken)
        assert (@client.send(:access_token)).is_a?(BitlyOAuth::AccessToken)
      end
      should 'return an access token from a token' do
        response = @client.get_access_token_from_token('token')
        assert response.is_a?(BitlyOAuth::AccessToken)
      end
      should 'set an access token from a token' do
        response = @client.set_access_token_from_token('token')
        assert response.is_a?(BitlyOAuth::AccessToken)
        assert (@client.send(:access_token)).is_a?(BitlyOAuth::AccessToken)
      end
    end
    context "requests to the bitly api" do
      setup do
        @client.set_access_token_from_token('token')
        stub_get('https://api-ssl.bit.ly/v3/bitly_pro_domain?access_token=token&domain=http%3A%2F%2Fpro.domain%2F', 'bitly_pro_domain.json')
      end
      context "bitly_pro_domain" do
        should 'return true when it is a bitly pro domain' do
          assert @client.bitly_pro_domain('http://pro.domain/')
        end
      end
      context "bitly_pro_domain" do
        should 'return true when it is a bitly pro domain' do
          assert @client.pro?('http://pro.domain/')
        end
      end
    end
  end
  context "#referring_domains" do
    setup do
      @client = BitlyOAuth::Client.new('id', 'secret')
      @client.set_access_token_from_token('token')
      stub_get('https://api-ssl.bit.ly/v3/link/referring_domains?access_token=token&link=http%3A%2F%2Fbit.ly%2Fsomelink%2F', 'referring_domains.json')
    end
    should "return an array" do
      assert @client.referring_domains('http://bit.ly/somelink/').is_a?(Array)
      assert_equal 1, @client.referring_domains('http://bit.ly/somelink/').map(&:class).uniq.size
      assert @client.referring_domains('http://bit.ly/somelink/').first.is_a?(BitlyOAuth::ReferringDomain)
    end
    should "all be the same class" do
      assert_equal 1, @client.referring_domains('http://bit.ly/somelink/').map(&:class).uniq.size
    end
    should "all be referring domains" do
      assert @client.referring_domains('http://bit.ly/somelink/').first.is_a?(BitlyOAuth::ReferringDomain)
    end
  end
end
