module BitlyOAuth
  # Day objects are created by the realtime_links method of a user
  class RealtimeLink
    attr_reader :clicks, :user_hash

    def initialize(options = {})
      @clicks    = options['clicks']
      @user_hash = options['user_hash']
    end

    # A convenience method to create a BitlyOAuth::Url from the data
    def create_url(client)
      BitlyOAuth::Url.new(client, 'user_clicks' => clicks, 'user_hash' => user_hash)
    end
  end
end
