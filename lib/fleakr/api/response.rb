module Fleakr
  module Api # :nodoc:
    
    # = Response
    #
    # Response objects contain Hpricot documents that are traversed and parsed by
    # the model objects.  This class is never called directly but is instantiated
    # during the request cycle (see: Fleakr::Api::MethodRequest.with_response!)
    #
    class Response

      # Creates a new response from a raw XML string returned from a Request
      def initialize(response_xml)
        @response_xml = response_xml
      end

      # Return a document-based representation of the XML contained in the
      # API response.  This is an Hpricot document object
      def body
        @body ||= Hpricot.XML(@response_xml)
      end

      # Did the response from the API contain errors?
      def error?
        (self.body/'rsp').attr('stat') != 'ok'
      end

      # Access the API error if one exists
      def error
        Fleakr::Objects::Error.new(self.body) if self.error?
      end

    end
  end
end