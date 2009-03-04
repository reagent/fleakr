module Fleakr
  module Api # :nodoc:
    
    # = MethodRequest
    # 
    # Handles all API requests that are non-upload related.  For upload requests see the
    # UploadRequest class.
    #
    class MethodRequest
      attr_reader :parameters, :method
      
      # Makes a request to the Flickr API and returns a valid Response object.  If
      # there are errors on the response it will raise an ApiError exception.  See 
      # MethodRequest#new for details about the additional parameters
      #
      def self.with_response!(method, additional_parameters = {})
        request = self.new(method, additional_parameters)
        response = request.send

        raise(Fleakr::ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end
      
      # Create a new request for the specified API method and pass along any additional
      # parameters.  The Flickr API uses namespacing for its methods - this is optional
      # when calling this method.
      #
      # This must be called after initializing the library with the required API key
      # see (#Fleakr.api_key=)
      #
      # The <tt>additional_parameters</tt> is a list of parameters to pass directly to 
      # the Flickr API call.  The exception to this is the <tt>:authenticate?</tt> option
      # that will force the call to not be authenticated if it is set to false (The default
      # behavior is to authenticate all calls when we have a token).
      #
      def initialize(method, additional_parameters = {})
        @parameters = ParameterList.new(additional_parameters)
        
        self.method = method
      end
   
      def method=(method) # :nodoc:
        @method = method.sub(/^(flickr\.)?/, 'flickr.')
        @parameters << ValueParameter.new('method', @method)
      end

      def send # :nodoc:
        logger.info("Sending request to: #{endpoint_uri}")
        response_xml = Net::HTTP.get(endpoint_uri)
        logger.debug("Response data:\n#{response_xml}")
        
        Response.new(response_xml)
      end
      
      private
      def endpoint_uri
        uri = URI.parse('http://api.flickr.com/services/rest/')
        uri.query = self.parameters.to_query
        uri
      end
      
    end
    
  end
end