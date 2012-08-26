module BitlyOAuth

  # A user requires a BitlyOAuth::AccessToken. The flow is as follows:
  #
  #     client = BitlyOAuth::Client.new(consumer_token, consumer_secret)
  #     client.authorize_url(redirect_url)
  #     #=> "https://bitly.com/oauth/authorize?client_id=id&type=code&redirect_uri=http%3A%2F%2Ftest.local%2Fbitly-oauth%2Fauth"
  #
  # Redirect your users to this url, when they authorize your application
  # they will be redirected to the url you provided with a code parameter.
  # Use that parameter, and the exact same redirect url as follows:
  #
  #     token = o.get_access_token_from_code(params[:code], redirect_url)
  #     #=> #<BitlyOAuth::AccessToken ...>
  #
  # Then use that access token to create your user object.
  #
  #    user = BitlyOAuth::User.new(token)
  class User

    def initialize(access_token)
      @access_token = access_token
    end

    # OAuth 2 endpoint that provides a list of top referrers (up to 500 per
    # day) for a given user’s bit.ly links, and the number of clicks per referrer. 
    #
    # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/referrers
    def referrers(options={})
      if @referrers.nil? || options.delete(:force)
        @referrers = get_method(:referrers, BitlyOAuth::Referrer, options)
      end
      @referrers
    end

    # OAuth 2 endpoint that provides a list of countries from which clicks
    # on a given user’s bit.ly links are originating, and the number of clicks per country. 
    #
    # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/countries
    def countries(options={})
      if @countries.nil? || options.delete(:force)
        @countries = get_method(:countries, BitlyOAuth::Country, options)
      end
      @countries
    end

    # OAuth 2 endpoint that provides a given user’s 100 most popular links
    # based on click traffic in the past hour, and the number of clicks per link. 
    #
    # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/realtime_links
    def realtime_links(options={})
      if @realtime_links.nil? || options.delete(:force)
        result = get(:realtime_links, options)
        @realtime_links = result['realtime_links'].map { |rs| BitlyOAuth::RealtimeLink.new(rs) }
      end
      @realtime_links
    end

    # OAuth 2 endpoint that provides the total clicks per day on a user’s bit.ly links.
    #
    # http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/user/clicks
    def clicks(options={})
      get_clicks(options)
      @clicks
    end

    # Displays the total clicks returned from the clicks method.
    def total_clicks(options={})
      get_clicks(options)
      @total_clicks
    end

    # Returns a Bitly Client using the credentials of the user.
    def client
      @client ||= begin
        client = BitlyOAuth::Client.new(@access_token.client.id, @access_token.client.secret)
        client.set_access_token_from_token(@access_token.token)
        client
      end
    end

    private

    def get_method(method, klass, options)
      result = get(method, options)
      result[method.to_s].map do |rs|
        rs.map do |obj|
          klass.new(obj)
        end
      end
    end

    def get_clicks(options={})
      if @clicks.nil? || options.delete(:force)
        result = get(:clicks, options)
        @clicks = result['clicks'].map { |rs| BitlyOAuth::Day.new(rs) }
        @total_clicks = result['total_clicks']
      end
    end

    def get(method, options)
      @access_token.get("user/#{method}", options)
    end
  end
end
