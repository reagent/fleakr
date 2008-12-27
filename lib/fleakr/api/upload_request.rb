module Fleakr
  module Api
    
    class UploadRequest
      
      attr_reader :parameters
      
      def self.with_response!(filename)
        request = self.new(filename)
        response = request.send
        
        raise(Fleakr::ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end
      
      def initialize(filename)
        @parameters = ParameterList.new(Fleakr.shared_secret, :authenticate? => true)
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
        @endpoint_uri ||= URI.parse('http://api.flickr.com/services/upload/')
      end
    end
    
  end
end