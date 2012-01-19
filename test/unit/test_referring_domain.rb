require 'test_helper'

class TestReferringDomain < Test::Unit::TestCase
  context "a referring domain" do
    setup do
      @referring_domain = BitlyOAuth::ReferringDomain.new
    end

    [:clicks, :domain].each do |method|
      should "respond to #{method}" do
        assert_respond_to @referring_domain, method
      end

      should "set #{method} when initializing" do
        referrer = BitlyOAuth::ReferringDomain.new(method.to_s => 'test')
        assert_equal 'test', referrer.send(method)
      end
    end
  end
end

