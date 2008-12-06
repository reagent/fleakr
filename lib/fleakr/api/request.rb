module Fleakr
  module Api
    class Request

      class ApiError < StandardError; end

      def self.with_response!(method, additional_parameters = {})
        request = Request.new(method, additional_parameters)
        response = request.send

        raise(ApiError, "Code: #{response.error.code} - #{response.error.message}") if response.error?

        response
      end

      def endpoint_uri
        uri = URI.parse('http://api.flickr.com/services/rest/')
        uri.query = self.query_parameters
        uri
      end

      def query_parameters
        @parameters.map {|key,value| "#{key}=#{CGI.escape(value)}" }.join('&')
      end

      def initialize(method, additional_parameters = {})
        method = method.sub(/^(flickr\.)?/, 'flickr.')

        default_parameters = {:api_key => Fleakr.api_key, :method => method}
        @parameters = default_parameters.merge(additional_parameters)
      end

      def send
        Response.new(Net::HTTP.get(self.endpoint_uri))
      end

    end
  end
end