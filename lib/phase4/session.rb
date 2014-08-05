require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @something = JSON.parse(cookie.value)
        end
      end
      @something = {} if @something.nil?
    end

    def [](key)
      @something.values_at(key)
    end

    def []=(key, val)
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
    end
  end
end
