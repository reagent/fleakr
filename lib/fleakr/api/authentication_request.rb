module Fleakr
  module Api # :nodoc:
    
    # = AuthenticationRequest
    #
    # Handles authentication requests for the web authentication method.
    # Requires that Fleakr.api_key and Fleakr.shared_secret both be set.
    #
    class AuthenticationRequest
      
      include Fleakr::Support::Request

      # The endpoint for the authentication request
      #
      def endpoint_url
        'http://flickr.com/services/auth/'
      end
      
      def response # :nodoc:
        Net::HTTP.get_response(endpoint_uri)
      end
      
      # The authorization URL that the user should be redirected to.
      #
      def authorization_url
        @authorization_url ||= response.header['Location']
      end
      
    end
    
  end
end