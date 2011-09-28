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

      # Return all attributes on the root response element unless there was an error
      def attributes
        @attributes ||= unless self.error?
          hpricot_attributes = (self.body/'rsp/photos' ).first.attributes
          Hash[ hpricot_attributes.to_hash.map do |key,value|
            value = value.to_i if value =~ /\A[0-9]+\z/
            [ key.to_sym, value ]
          end ]
        end
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
