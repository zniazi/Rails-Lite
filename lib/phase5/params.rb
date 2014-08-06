require 'uri'
require 'pry-debugger'
require 'webrick'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = Hash.new
      parse_www_encoded_form(req.query_string) unless req.nil?
      # parse_www_encoded_form(req.body) unless req.nil?
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # private

    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return nil if www_encoded_form.nil?

      URI.decode_www_form(www_encoded_form).each do |el|
        if parse_key(el[0]).length > 1
          nested_keys = parse_key(el[0]).reverse!
          @params = { nested_keys.shift => el[1] }
          @params = { nested_keys.shift => @params } until nested_keys.empty?
        else
          @params[el[0]] = el[1]
        end
      end
      # URI.decode_www_form(www_encoded_form).each do |el|
#         nested_keys = parse_key(el[0]).reverse!
#         @params = { nested_keys.shift => el[1] }
#         until nested_keys.empty?
#           @params = { nested_keys.shift => @params }
#         end
#
#         @params
      # end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

# puts Phase5::Params.new(WEBrick::HTTPRequest.new(Logger: nil)).parse_www_encoded_form("user[address][street]=main&user[address][zip]=89436")
# p Phase5::Params.new(WEBrick::HTTPRequest.new(Logger: nil)).parse_key("user_address_street")


