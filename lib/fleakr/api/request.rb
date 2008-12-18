module Fleakr
  module Api # :nodoc:
    
    # = Request
    #
    # Performs requests against the Flickr API and returns response objects (Flickr::Api::Response)
    # that contain Hpricot documents for further parsing and inspection.  This class is used internally
    # in all the defined model objects.
    #
    class Request

      # Generic catch-all exception for any API errors
      class ApiError < StandardError; end

      # Makes a request to the Flickr API and returns a valid Response object.  If
      # there are errors on the response it will raise an ApiError exception.  See 
      # #Fleakr::Api::Request.new for details about the additional parameters
      #
      def self.with_response!(method, additional_parameters = {})
        request = Request.new(method, additional_parameters)
        response = request.send

        raise(ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

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
        method = method.sub(/^(flickr\.)?/, 'flickr.')
        
        @sign = additional_parameters.delete(:sign?)

        default_parameters = {:api_key => Fleakr.api_key, :method => method}
        @parameters = default_parameters.merge(additional_parameters)
      end

      # Should this call be signed?
      #
      def sign?
        (@sign == true) ? true : false
      end

      def send # :nodoc:
        Response.new(Net::HTTP.get(endpoint_uri))
      end

      # The list of parameters that should be sent to the Flickr API.  If this call
      # should be signed (e.g. sign? returns true), then this method will add the
      # necessary <tt>:api_sig</tt> name/value pair
      #
      def parameters
        self.sign? ? @parameters.merge(:api_sig => signature) : @parameters
      end

      private
      def endpoint_uri
        uri = URI.parse('http://api.flickr.com/services/rest/')
        uri.query = query_parameters
        uri
      end

      def query_parameters
        self.parameters.map {|key,value| "#{key}=#{CGI.escape(value)}" }.join('&')
      end

      def signature
        sorted_pairs = @parameters.sort {|a,b| a.to_s <=> b.to_s }.flatten.join
        Digest::MD5.hexdigest("#{Fleakr.shared_secret}#{sorted_pairs}")
      end

    end
  end
end