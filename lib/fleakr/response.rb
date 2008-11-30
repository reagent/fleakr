module Fleakr
  class Response
    
    def initialize(response_xml)
      @response_xml = response_xml
    end

    def body
      @body ||= Hpricot.XML(@response_xml)
    end
    
    def error?
      (self.body/'rsp').attr('stat') != 'ok'
    end
    
    def error
      Error.new(self.body) if self.error?
    end
    
  end
end