module Bonus
  class Flash

    attr_accessor :flash_hash

    def initialize(req)
      req.cookies.each do |cookie|
        @flash_hash = JSON.parse(cookie.value) if cookie.name == '_flash'
      end
      if @flash_hash.nil?
        @flash_hash = {}
      else
        @flash_hash.keep_if { |key, value| value <= 1 }
      end
    end

    def [](key)
      return @flash_hash[key][0] if @flash_hash[key][1] == true
    end

    def []=(key, value)
      @flash_hash[key] = [value, 0]
    end

    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_flash', @flash_hash.to_json)
    end
  end
end