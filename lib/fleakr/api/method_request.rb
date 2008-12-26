module Fleakr
  module Api
    
    class MethodRequest
      attr_reader :parameters, :method
      
      # Makes a request to the Flickr API and returns a valid Response object.  If
      # there are errors on the response it will raise an ApiError exception.  See 
      # #Fleakr::Api::MethodRequest.new for details about the additional parameters
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
      # the Flickr API call.  The exception is the <tt>:sign?</tt> option that determines
      # whether this call should automatically be signed.
      #
      def initialize(method, additional_parameters = {})
        @parameters = ParameterList.new(Fleakr.shared_secret, additional_parameters)
        
        self.method = method
      end
   
      def method=(method)
        @method = method.sub(/^(flickr\.)?/, 'flickr.')
        @parameters << ValueParameter.new('method', @method)
      end

      def send # :nodoc:
        Response.new(Net::HTTP.get(endpoint_uri))
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