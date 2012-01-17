require 'test_helper'

class TestBitlyrError < Test::Unit::TestCase
  should "create a new bitlyr client" do
    res = mock(:status => 'code', :reason => 'message')
    error = BitlyrError.new(res)
    assert_equal "message - 'code'", error.message
    assert_equal "message - 'code'", error.msg
    assert_equal "code", error.code
  end
end
