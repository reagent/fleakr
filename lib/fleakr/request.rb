module Fleakr
  class Request

    include HTTParty
    
    base_uri 'api.flickr.com'
    
    attr_reader :response

    def self.api_key=(key)
      @api_key = key
    end
    
    def self.api_key
      @api_key
    end

    def initialize(method_name, params = {})
      @method_name = method_name.sub(/^flickr\./, '')
      @params      = params
    end
    
    def send
      params = @params.merge(:method => "flickr.#{@method_name}", :api_key => self.class.api_key)
      response_data = self.class.get('/services/rest/', :query => params)

      @response = Response.new(response_data['rsp'])
    end
    
  end
end