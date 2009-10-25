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
      flickr_attribute :user_id, :from => 'auth/user@nsid'
      flickr_attribute :user_name, :from => 'auth/user@username' 
      flickr_attribute :full_name, :from => 'auth/user@fullname'
      
      # Retrieve a full authentication token from the supplied mini-token (e.g. 123-456-789)
      #
      def self.from_mini_token(mini_token)
        from :mini_token, mini_token
      end
      
      # Retrieve a full authentication token from the supplied auth_token string
      # (e.g. 45-76598454353455)
      # 
      def self.from_auth_token(auth_token)
        from :auth_token, auth_token
      end
      
      # Retrieve a full authentication token from the supplied frob
      def self.from_frob(frob)
        from :frob, frob
      end
      
      def self.from(thing, value) # :nodoc:
        api_methods = {
          :mini_token => 'getFullToken',
          :auth_token => 'checkToken',
          :frob       => 'getToken'
        }
        
        method = "auth.#{api_methods[thing]}"
        
        parameters = {thing => value, :authenticate? => false}
        response = Fleakr::Api::MethodRequest.with_response!(method, parameters)
        
        self.new(response.body)
      end
      
      def user
        User.find_by_id(user_id)
      end
      
    end
    
  end
end