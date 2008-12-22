module Fleakr
  module Api # :nodoc:
    
    # = Request
    #
    # Performs requests against the Flickr API and returns response objects (Flickr::Api::Response)
    # that contain Hpricot documents for further parsing and inspection.  This class is used internally
    # in all the defined model objects.
    #
    module Request

      # Generic catch-all exception for any API errors
      class ApiError < StandardError; end

      def self.token
        if @token.nil?
          if !Fleakr.auth_token.nil?
            @token = Fleakr::Objects::AuthenticationToken.from_auth_token(Fleakr.auth_token)
          else
            @token = Fleakr::Objects::AuthenticationToken.from_mini_token(Fleakr.mini_token)
          end
        end
        @token
      end
      
      def self.included(other)
        other.send(:include, Fleakr::Api::Request::InstanceMethods)
      end
      
      module InstanceMethods

        # Should this call be signed?
        #
        def sign?
          (authenticate? || @sign == true) ? true : false
        end

        # Should this call be authenticated?
        #
        def authenticate?
          (@authenticate == true) ? true : false 
        end

        # The list of parameters that should be sent to the Flickr API.  If this call
        # should be authenticated (e.g. authenticate? returns true), then this method will add the
        # necessary <tt>:auth_token</tt> name/value pair
        #
        def parameters
          parameters = @parameters || {}
          parameters.merge!(:auth_token => Request.token.value) if self.authenticate?
          
          parameters
        end

        def send # :nodoc:
          Response.new(Net::HTTP.get(endpoint_uri))
        end

        private
        def query_parameters
          parameters = self.parameters
          parameters.merge!(:api_sig => signature) if self.sign?
          
          parameters
        end

        def signature
          signature_params = self.parameters.reject {|k,v| k == :api_sig }
          sorted_pairs = signature_params.sort {|a,b| a.to_s <=> b.to_s }.flatten
          Digest::MD5.hexdigest("#{Fleakr.shared_secret}#{sorted_pairs.join}")
        end

      end

    end
  end
end
