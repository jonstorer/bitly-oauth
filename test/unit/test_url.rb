require 'test_helper'

class TestUrl < Test::Unit::TestCase
  context "with a client" do
    setup do
      @client = BitlyOAuth.new('client_id', 'client_secret')
      @client.set_access_token_from_token('token')
    end
    context "and a url" do
      setup do
        @url = BitlyOAuth::Url.new(@client)
      end
      [:short_url,
       :long_url,
       :user_hash,
       :global_hash,
       :user_clicks,
       :global_clicks,
       :new_hash?,
       :title,
       :created_by,
       :referrers,
       :referring_domains,
       :countries,
       :clicks_by_minute,
       :clicks_by_day].each do |method|
        should "respond to #{method}" do
          assert_respond_to @url, method
        end
      end
    end

    context "and an expanded url" do
      context "getting click data" do
        setup do
          stub_get("https://api-ssl.bit.ly/v3/clicks?access_token=token&hash=9uX1TE", ['9uX1TEclicks.json', '9uX1TEclicks2.json'])
          @url = BitlyOAuth::Url.new(@client, 'hash' => '9uX1TE')
        end
        should "get clicks when global clicks is called" do
          assert_equal 81, @url.global_clicks
        end
        should "get clicks when user clicks is called" do
          assert_equal 0, @url.user_clicks
        end
        should "get global clicks the first time and only update when forced" do
          assert_equal 81, @url.global_clicks
          assert_equal 81, @url.global_clicks
          assert_equal 82, @url.global_clicks(:force => true)
        end
        should "get user clicks the first time and only update when forced" do
          assert_equal 0, @url.user_clicks
          assert_equal 0, @url.user_clicks
          assert_equal 1, @url.user_clicks(:force => true)
        end
      end
      context "getting info" do
        setup do
          stub_get("https://api-ssl.bit.ly/v3/info?hash=9uX1TE&access_token=token", ['9uX1TEinfo.json', '9uX1TEinfo2.json'])
          @url = BitlyOAuth::Url.new(@client, 'hash' => '9uX1TE')
        end
        should "get info when title is called" do
          assert_equal "A title", @url.title
        end
        should "get info when created_by is called" do
          assert_equal 'philnash', @url.created_by
        end
        should "get title the first time and only update when forced" do
          assert_equal "A title", @url.title
          assert_equal "A title", @url.title
          assert_equal "A New Title", @url.title(:force => true)
        end
        should "get the creator the first time and only update when forced" do
          assert_equal 'philnash', @url.created_by
          assert_equal 'philnash', @url.created_by
          # updating just to prove it works, creator is unlikely to change
          assert_equal 'philnash2', @url.created_by(:force => true)
        end
        context "steps to prevent an infinite loop" do
          should "doesn't get info if the title is an empty string" do
            @url = BitlyOAuth::Url.new(@client, 'hash' => '9uX1TE', 'title' => '')
            assert_equal "", @url.title
          end
          should "doesn't get info if the title is explicitly set to nil" do
            @url = BitlyOAuth::Url.new(@client, 'hash' => '9uX1TE', 'title' => nil)
            assert_equal "", @url.title
          end
        end
      end
      context "getting referrers" do
        setup do
          stub_get("https://api-ssl.bit.ly/v3/referrers?access_token=token&hash=djZ9g4", ['referrer_hash.json', 'referrer_hash2.json'])
          @url = BitlyOAuth::Url.new(@client, 'hash' => 'djZ9g4')
        end
        should 'get referrers when called' do
          assert_instance_of Array, @url.referrers
          assert_instance_of BitlyOAuth::Referrer, @url.referrers.first
          assert_equal 'direct', @url.referrers.first.referrer
          assert_equal 62, @url.referrers.first.clicks
        end
        should 'force update when told to' do
          assert_equal 62, @url.referrers.first.clicks
          assert_equal 62, @url.referrers.first.clicks
          assert_equal 63, @url.referrers(:force => true).first.clicks
        end
      end
      context "getting referring_domains" do
        should 'get referring_domains when called' do
          @client.stubs(:referring_domains => [ BitlyOAuth::ReferringDomain.new( {'domain' => 'direct', 'clicks' => 62} ) ] )
          url = BitlyOAuth::Url.new(@client, 'hash' => 'djZ9g4')
          assert_instance_of Array, url.referring_domains
          assert_instance_of BitlyOAuth::ReferringDomain, url.referring_domains.first
          assert_equal 'direct', url.referring_domains.first.domain
          assert_equal 62, url.referring_domains.first.clicks
        end
        should 'force update when told to' do
          @client.stubs(:referring_domains => [ BitlyOAuth::ReferringDomain.new( {'domain' => 'direct', 'clicks' => 62} ) ] )
          url = BitlyOAuth::Url.new(@client, 'hash' => 'djZ9g4')
          assert_equal 62, url.referring_domains.first.clicks
          url.instance_eval{ @client.stubs(:referring_domains => [ BitlyOAuth::ReferringDomain.new( {'domain' => 'direct', 'clicks' => 63} ) ] ) }
          assert_equal 62, url.referring_domains.first.clicks
          assert_equal 63, url.referring_domains(:force => true).first.clicks
        end
      end
      context "getting countries" do
        setup do
          stub_get("https://api-ssl.bit.ly/v3/countries?hash=djZ9g4&access_token=token", ['country_hash.json', 'country_hash2.json'])
          @url = BitlyOAuth::Url.new(@client, 'hash' => 'djZ9g4')
        end
        should 'get countries when called' do
          assert_instance_of Array, @url.countries
          assert_instance_of BitlyOAuth::Country, @url.countries.first
          assert_equal 'US', @url.countries.first.country
          assert_equal 58, @url.countries.first.clicks
        end
        should 'force update when told to' do
          assert_equal 58, @url.countries.first.clicks
          assert_equal 58, @url.countries.first.clicks
          assert_equal 59, @url.countries(:force => true).first.clicks
        end
      end
      context "getting clicks by minute" do
        setup do
          @short_url = "http://j.mp/9DguyN"
          stub_get("https://api-ssl.bit.ly/v3/clicks_by_minute?access_token=token&shortUrl=#{CGI.escape(@short_url)}", ['clicks_by_minute1_url.json', 'clicks_by_minute2_url.json'])
          @url = BitlyOAuth::Url.new(@client, 'short_url' => @short_url)
        end
        should 'get clicks_by_minute when called' do
          assert_instance_of Array, @url.clicks_by_minute
          assert_equal 0, @url.clicks_by_minute[0]
        end
        should 'force update when told to' do
          assert_equal 0, @url.clicks_by_minute[2]
          assert_equal 0, @url.clicks_by_minute[2]
          assert_equal 1, @url.clicks_by_minute(:force => true)[2]
        end
      end
      context "getting clicks by day" do
        setup do
          @hash = "9DguyN"
          stub_get("https://api-ssl.bit.ly/v3/clicks_by_day?hash=#{@hash}&access_token=token", ['clicks_by_day1.json', 'clicks_by_day2.json'])
          @url = BitlyOAuth::Url.new(@client, 'hash' => @hash)
        end
        should 'get clicks_by_day when called' do
          assert_instance_of Array, @url.clicks_by_day
          assert_instance_of BitlyOAuth::Day, @url.clicks_by_day[0]
        end
        should 'force update when told to' do
          assert_equal 1, @url.clicks_by_day[0].clicks
          assert_equal 1, @url.clicks_by_day[0].clicks
          assert_equal 2, @url.clicks_by_day(:force => true)[0].clicks
        end
      end
    end
  end
end
