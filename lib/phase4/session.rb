require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @session_cookie = JSON.parse(req.cookies.find { |c| c.name == "_rails_lite_app" }.value)
      @session_cookie = {} if @session_cookie.nil?
    end

    def [](key)
      @session_cookie[key]
    end

    def []=(key, val)
      @session_cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session_cookie.to_json)
    end
  end
end
