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
    
  end
end