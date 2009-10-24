module Fleakr
  module Api # :nodoc:
    
    # = UploadRequest
    # 
    # This implements the upload functionality of the Flickr API which is needed
    # to create new photos and replace the photo content of existing photos
    #
    class UploadRequest

      ENDPOINT_URIS = {
        :create => 'http://api.flickr.com/services/upload/',
        :update => 'http://api.flickr.com/services/replace/'
      }

      attr_reader :parameters, :type

      # Send a request and return a Response object.  If an API error occurs, this raises
      # a Fleakr::ApiError with the reason for the error.  See UploadRequest#new for more 
      # details.
      #
      def self.with_response!(filename, type = :create, options = {})
        request = self.new(filename, type, options)
        response = request.send
        
        raise(Fleakr::ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end
      
      # Create a new UploadRequest with the specified filename, type, and options.  Type
      # is one of <tt>:create</tt> or <tt>:update</tt> to specify whether we are saving a new
      # image or replacing an existing one.  
      #
      # For a list of available options, see the documentation in Fleakr::Objects::Photo
      #
      def initialize(filename, type = :create, options = {})
        @type    = type
        @options = options
        
        @parameters = ParameterList.new(upload_options)
        parameters.add_upload_option(:photo, filename)
      end
      
      # A list of upload options for this upload request (see Fleakr::Api::Option)
      #
      def upload_options
        option_list = @options.map {|key, value| Option.for(key, value) }
        option_list.inject({}) {|hash, option| hash.merge(option.to_hash)}
      end
      
      def headers # :nodoc:
        {'Content-Type' => "multipart/form-data; boundary=#{self.parameters.boundary}"}
      end

      def send # :nodoc:
        response = Net::HTTP.start(endpoint_uri.host, endpoint_uri.port) do |http| 
          logger.info("Sending upload request to: #{endpoint_uri}")
          logger.debug("Request data:\n#{self.parameters.to_form}")
          logger.debug("Request headers:\n#{self.headers.inspect}")
          
          http.post(endpoint_uri.path, self.parameters.to_form, self.headers)
        end
        logger.debug("Response data:\n#{response.body}")
        Response.new(response.body)
      end
      
      private
      def endpoint_uri
        @endpoint_uri ||= URI.parse(ENDPOINT_URIS[self.type])
      end
    end
    
  end
end