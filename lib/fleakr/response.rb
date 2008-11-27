module Fleakr
  class Response
    
    def initialize(response_data)
      @response_data = response_data
    end
    
    def values
      @response_data[@response_data.keys.first]
    end
    
    def error?
      @response_data.keys.first == 'err'
    end
    
  end
end