module Fleakr
  module Api # :nodoc:

    # = Request
    #
    # Performs requests against the Flickr API and returns response objects (Flickr::Api::Response)
    # that contain Hpricot documents for further parsing and inspection.  This class is used internally
    # in all the defined model objects.
    #
    module Request

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

    end
  end
end
