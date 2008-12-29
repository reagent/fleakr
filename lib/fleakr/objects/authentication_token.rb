module Fleakr
  module Objects # :nodoc:
    
    # = AuthenticationToken
    #
    # This class represents an authentication token used for API calls that 
    # require authentication before they can be used
    #
    # == Attributes
    #
    # [value] The token value that is used in subsequent API calls
    # [permissions] The permissions granted to this application (read / write / delete)
    #
    class AuthenticationToken
      
      include Fleakr::Support::Object
      
      flickr_attribute :value, :from => 'auth/token'
      flickr_attribute :permissions, :from => 'auth/perms'
      
      # Retrieve a full authentication token from the supplied mini-token (e.g. 123-456-789)
      #
      def self.from_mini_token(token)
        parameters = {:mini_token => token, :sign? => true}
        response = Fleakr::Api::MethodRequest.with_response!('auth.getFullToken', parameters)
        
        self.new(response.body)
      end
      
      # Retrieve a full authentication token from the supplied auth_token string
      # (e.g. 45-76598454353455)
      # 
      def self.from_auth_token(token)
        parameters = {:auth_token => token, :sign? => true}
        response = Fleakr::Api::MethodRequest.with_response!('auth.checkToken', parameters)
        
        self.new(response.body)
      end
      
    end
    
  end
end