module BitlyOAuth
  class User
    def initialize(access_token)
      @access_token = access_token
    end

    def referrers(options={})
      if @referrers.nil? || options.delete(:force)
        @referrers = get_method(:referrers, BitlyOAuth::Referrer, options)
      end
      @referrers
    end

    def countries(options={})
      if @countries.nil? || options.delete(:force)
        @countries = get_method(:countries, BitlyOAuth::Country, options)
      end
      @countries
    end

    def realtime_links(options={})
      if @realtime_links.nil? || options.delete(:force)
        result = get(:realtime_links, options)
        @realtime_links = result['realtime_links'].map { |rs| BitlyOAuth::RealtimeLink.new(rs) }
      end
      @realtime_links
    end

    def clicks(options={})
      get_clicks(options)
      @clicks
    end

    def total_clicks(options={})
      get_clicks(options)
      @total_clicks
    end

    def client
      @client ||= BitlyOAuth::Client.new(@access_token)
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
      client.v3("user/#{method}", options)
    end
  end
end
