require 'test_helper'

class TestClient < Test::Unit::TestCase
  context 'creating a new client' do
    should 'initialize with clinet id and secret' do
      assert_nothing_raised do
        BitlyOAuth::Client.new('token')
      end
    end

    should 'raise an exception when bad arguments are used' do
      assert_raise ArgumentError do
        BitlyOAuth::Client.new('Something', 'Else')
      end
    end
  end

  context '#bitly_pro_domain' do
    setup do
      @client = BitlyOAuth.new('token')
      stub_get('https://api-ssl.bit.ly/v3/bitly_pro_domain?access_token=token&domain=http%3A%2F%2Fpro.domain%2F', 'bitly_pro_domain.json')
    end

    should 'return true when it is a bitly pro domain' do
      assert @client.bitly_pro_domain('http://pro.domain/')
    end

    should 'aliases #pro? to #bitly_pro_domain' do
      assert @client.pro?('http://pro.domain/')
    end
  end

  context '#referring_domains' do
    setup do
      @client = BitlyOAuth::Client.new('token')
      stub_get('https://api-ssl.bit.ly/v3/link/referring_domains?access_token=token&link=http%3A%2F%2Fbit.ly%2Fsomelink%2F', 'referring_domains.json')
    end

    should 'return an array' do
      assert          @client.referring_domains('http://bit.ly/somelink/').is_a?(Array)
      assert_equal 1, @client.referring_domains('http://bit.ly/somelink/').map(&:class).uniq.size
      assert          @client.referring_domains('http://bit.ly/somelink/').first.is_a?(BitlyOAuth::ReferringDomain)
    end

    should 'all be the same class' do
      assert_equal 1, @client.referring_domains('http://bit.ly/somelink/').map(&:class).uniq.size
    end

    should 'all be referring domains' do
      assert @client.referring_domains('http://bit.ly/somelink/').first.is_a?(BitlyOAuth::ReferringDomain)
    end
  end
end
