module BitlyOAuth
  class Client
    extend Forwardable
    delegate [ :get, :post ] => :access_token

    BASE_URL = 'https://api-ssl.bit.ly/v3/'

    def initialize(client_id, client_secret)
      @client_id     = client_id
      @client_secret = client_secret
    end

    def authorize_url(redirect_url)
      client.auth_code.authorize_url(:redirect_uri => redirect_url).gsub(/api-ssl.bit.ly/,'bitly.com')
    end

    def get_access_token_from_code(code, redirect_url)
      access_token = client.auth_code.get_token(code, :redirect_uri => redirect_url, :parse => :query)
      BitlyOAuth::AccessToken.new(access_token)
    end

    def set_access_token_from_code(*args)
      @access_token ||= get_access_token_from_code(*args)
    end

    def get_access_token_from_token(token, params={})
      params.stringify_keys!
      access_token = ::OAuth2::AccessToken.new(client, token, params)
      BitlyOAuth::AccessToken.new(access_token)
    end

    def set_access_token_from_token(*args)
      @access_token ||= get_access_token_from_token(*args)
    end

    def bitly_pro_domain(domain)
      get(:bitly_pro_domain, :domain => domain)['bitly_pro_domain']
    end
    alias :pro? :bitly_pro_domain

    # Validates a login and api key
    def validate(x_login, x_api_key)
      get(:validate, :x_login => x_login, :x_apiKey => x_api_key)['valid'] == 1
    end
    alias :valid? :validate

    def shorten(long_url, options={})
      response = get(:shorten, { :longUrl => long_url }.merge(options))
      BitlyOAuth::Url.new(self, response)
    end

    def expand(input)
      get_method(:expand, input)
    end

    def clicks(input)
      get_method(:clicks, input)
    end

    def info(input)
      get_method(:info, input)
    end

    def clicks_by_minute(input)
      get_method(:clicks_by_minute, input)
    end

    def clicks_by_day(input, options={})
      options.reject! { |k, v| k.to_s != 'days' }
      get_method(:clicks_by_day, input, options)
    end

    def countries(input)
      get_single_method(:countries, input)
    end

    def referrers(input)
      get_single_method(:referrers, input)
    end

    def referring_domains(link, options={})
      response = get('link/referring_domains', :link => link)
      response['referring_domains'].map do |referring_domain|
        BitlyOAuth::ReferringDomain.new(referring_domain)
      end
    end

    def lookup(input)
      input = input.to_a
      response = get(:lookup, :url => input)
      results = response['lookup'].inject([]) do |results, url|
        index = input.index(url['long_url'] = url.delete('url'))
        if url['error'].nil?
          results[index] = BitlyOAuth::Url.new(self, url)
        else
          results[index] = BitlyOAuth::MissingUrl.new(url)
        end
        input[index] = nil
        results
      end
      results.length > 1 ? results : results[0]
    end

    private

    def get_method(method, input, options={})
      options.symbolize_keys!
      input = input.to_a

      input.each do |i|
        (options[key_for(i)] ||= []) << i
      end

      response = get(method, options)

      results = response[method.to_s].inject([]) do |results, url|
        result_index = input.index(url['short_url'] || url['hash']) || input.index(url['global_hash'])

        if url['error'].nil?
          results[result_index] = BitlyOAuth::Url.new(self, url)
        else
          results[result_index] = BitlyOAuth::MissingUrl.new(url)
        end
        input[result_index] = nil
        results
      end
      results.length > 1 ? results : results[0]
    end

    def get_single_method(method, input)
      raise ArgumentError.new("This method only takes a hash or url input") unless input.is_a? String

      response = get(method, key_for(input) => input.to_a)
      BitlyOAuth::Url.new(self, response)
    end

    def client
      @client ||= ::OAuth2::Client.new(@client_id, @client_secret, :site => BASE_URL, :token_url => '/oauth/access_token')
    end

    def access_token
      @access_token
    end

    def key_for(input)
      input.match(/^http:\/\//) ? :shortUrl : :hash
    end
  end
end
