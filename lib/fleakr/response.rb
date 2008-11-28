module Fleakr
  class Response
    
    def initialize(response_data)
      @response_data = response_data
    end
    
    def values_for(key)
      @response_data[key.to_s]
    end
    
    def error?
      @response_data.keys.include?('err')
    end
    
  end
end