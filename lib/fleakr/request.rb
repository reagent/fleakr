module Fleakr
  class Request

    def self.api_key=(key)
      @api_key = key
    end
    
    def self.api_key
      @api_key
    end
    
    def endpoint_uri
      uri = URI.parse('http://api.flickr.com/services/rest/')
      uri.query = self.query_parameters
      uri
    end
    
    def query_parameters
      @parameters.map {|key,value| "#{key}=#{value}" }.join('&')
    end
    
    def initialize(method, additional_parameters = {})
      method = method.sub(/^(flickr\.)?/, 'flickr.')
      
      default_parameters = {:api_key => self.class.api_key, :method => method}
      @parameters = default_parameters.merge(additional_parameters)
    end
    
    def send
      Response.new(Net::HTTP.get(self.endpoint_uri))
    end
    
  end
end