require 'test_helper'

class TestApiKey < Test::Unit::TestCase
  context "making a successful request" do
    should "return a hash when successful" do
      stub_get(%r{http://api\.bit\.ly/v3}, 'success.json')
      strategy = Bitlyr::Strategy::ApiKey.new(login_fixture, api_key_fixture)
      assert_kind_of Hash, strategy.request(:get, "/")
    end
  end
  context "making an unsuccessful request" do
    should "raise a bitlyr error when unsuccessful" do
      assert_raise BitlyrError do
        stub_get(%r{http://api\.bit\.ly/v3}, 'failure.json')
        strategy = Bitlyr::Strategy::ApiKey.new(login_fixture, api_key_fixture)
        strategy.request(:get, "/")
      end
    end
  end
end
