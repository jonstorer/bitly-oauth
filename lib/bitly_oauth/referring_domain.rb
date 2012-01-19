module BitlyOAuth
  class ReferringDomain
    attr_reader :clicks, :domain

    def initialize(options={})
      @clicks = options['clicks']
      @domain = options['domain']
    end
  end
end

