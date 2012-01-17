require 'test_helper'

class TestDay < Test::Unit::TestCase
  context "a day" do
    setup do
      @day = Bitlyr::Day.new
    end
    [:clicks, :day_start].each do |method|
      should "respond to #{method}" do
        assert_respond_to @day, method
      end
    end
    should "set clicks when initializing" do
      day = Bitlyr::Day.new('clicks' => 12)
      assert_equal 12, day.clicks
    end
    should "set day to a time object when initialising" do
      day = Bitlyr::Day.new('day_start' => 1290488400)
      assert_equal Time.parse('2010/11/23'), day.day_start
    end
  end
end
