module BitlyOAuth
  class Client
    include HTTParty
    base_uri 'https://api-ssl.bit.ly/'

    def initialize(access_token)
      @access_token = access_token
    end

    def bitly_pro_domain(domain)
      v3(:bitly_pro_domain, :domain => domain)['bitly_pro_domain']
    end
    alias :pro? :bitly_pro_domain

    def validate(x_login, x_api_key)
      v3(:validate, :x_login => x_login, :x_apiKey => x_api_key)['valid'] == 1
    end
    alias :valid? :validate

    def shorten(long_url, options={})
      response = v3(:shorten, { :longUrl => long_url }.merge(options))
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
      response = v3('link/referring_domains', :link => link)
      response['referring_domains'].map do |referring_domain|
        BitlyOAuth::ReferringDomain.new(referring_domain)
      end
    end

    def lookup(input)
      input = input.to_a
      response = v3(:lookup, :url => input)
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

    def get_single_method(method, input)
      raise ArgumentError.new("This method only takes a hash or url input") unless input.is_a? String

      response = v3(method, key_for(input) => input.to_a)
      BitlyOAuth::Url.new(self, response)
    end

    def get_method(method, input, options={})
      options = ParamsHash[ options ]
      options.symbolize_keys!
      input = input.to_a

      input.each do |i|
        (options[key_for(i)] ||= []) << i
      end

      response = v3(method, options)

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

    def key_for(input)
      input.match(/^http:\/\//) ? :shortUrl : :hash
    end

    def v3(method, options)
      get("v3/#{method}", options)
    end
    public :v3

    def get(path, params = {})
      response = self.class.get("/#{path}", query(params))
      response = BitlyOAuth::Response.new(response)
      if response.success?
        response.body
      else
        raise BitlyOAuth::Error.new(response)
      end
    end

    def query(params)
      { :query => ParamsHash[ { :access_token => @access_token }.merge(params) ].to_query }
    end
  end
end
