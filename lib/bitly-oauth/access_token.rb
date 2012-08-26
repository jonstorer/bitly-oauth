module BitlyOAuth
  class AccessToken
    extend Forwardable
    delegate [ :client, :token ] => :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    def get(method, options)
      request(:get, method, options)
    end

    def post(method, options)
      request(:post, method, options)
    end

    private
    def request(verb, method, options={})
      response = access_token.send(verb, method.to_s, :params => params(options), :parse => :json)
      response = BitlyOAuth::Response.new(response)
      if response.success?
        response.body
      else
        raise BitlyOAuth::Error.new(response)
      end
    end

    def params(options={})
      { :access_token => access_token.token }.merge(options)
    end

    def access_token
      @access_token
    end
  end
end
