module Fleakr
  module Api
    
    class UploadRequest

      ENDPOINT_URIS = {
        :create => 'http://api.flickr.com/services/upload/',
        :update => 'http://api.flickr.com/services/replace/'
      }
      
      attr_reader :parameters, :type
      
      def self.with_response!(filename, options = {})
        request = self.new(filename, options)
        response = request.send
        
        raise(Fleakr::ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end
      
      def initialize(filename, options = {})
        type_options = options.extract!(:type)
        options.merge!(:authenticate? => true)
        
        @type = type_options[:type] || :create
        
        @parameters = ParameterList.new(Fleakr.shared_secret, options)
        @parameters << FileParameter.new('photo', filename)
      end
      
      def headers
        {'Content-Type' => "multipart/form-data; boundary=#{self.parameters.boundary}"}
      end

      def send
        response = Net::HTTP.start(endpoint_uri.host, endpoint_uri.port) do |http| 
          http.post(endpoint_uri.path, self.parameters.to_form, self.headers)
        end
        Response.new(response.body)
      end
      
      private
      def endpoint_uri
        @endpoint_uri ||= URI.parse(ENDPOINT_URIS[self.type])
      end
    end
    
  end
end