require 'test_helper'

class TestError < Test::Unit::TestCase
  should "create a new bitly-oauth client" do
    res = mock(:status => 'code', :reason => 'message')
    error = BitlyOAuth::Error.new(res)
    assert_equal "message - 'code'", error.message
    assert_equal "message - 'code'", error.msg
    assert_equal "code", error.code
  end
end
