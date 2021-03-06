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
      @params = route_params
      parse_www_encoded_form(req.query_string) unless req.nil?
      parse_www_encoded_form(req.body) unless req.nil?
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
      @params ||= {}
      URI.decode_www_form(www_encoded_form).each do |el|
        if parse_key(el[0]).length > 1
          nested_keys = parse_key(el[0]).reverse!
          new_params = { nested_keys.shift => el[1] }
          new_params = { nested_keys.shift => new_params } until nested_keys.empty?
          key = new_params.keys.first
          if @params.keys.include?(key)
            @params[key] = @params[key].merge(new_params[key])
          else
            @params[key] = new_params[key]
          end
        else
          @params[el[0]] = el[1]
        end
      end
      p @params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

Phase5::Params.new(WEBrick::HTTPRequest.new(Logger: nil)).parse_www_encoded_form("cat[name]=tommy&cat[owner]=zak")
Phase5::Params.new(WEBrick::HTTPRequest.new(Logger: nil)).parse_www_encoded_form("key=val&key2=val2")


