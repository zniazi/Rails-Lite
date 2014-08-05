require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    def initialize(req, route_params = {})
      @params = Hash.new
      parse_www_encoded_form(req.query_string) unless req.nil?
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return nil if www_encoded_form.nil?
      URI.decode_www_form(www_encoded_form).each { |el| @params[el[0]] = el[1] }
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      ind = []
      key.each_char.with_index do |char, i|
        ind << i if /\[+|\]+/ =~ char
      end
      arr = []
      starting_index = 0
      ind.each do |i|
        arr << key[starting_index, i]
        starting_index += i + 1
      end
      arr
    end
  end
end
