module Fleakr
  module Support # :nodoc:all
    module Request
   
      attr_reader :parameters

      def initialize(additional_parameters = {})
        authenticate = additional_parameters.delete(:authenticate?)
        authenticate = authenticate.nil? ? true : authenticate
        
        @parameters = Fleakr::Api::ParameterList.new(additional_parameters, authenticate)
      end

      def endpoint_uri
        uri = URI.parse(endpoint_url)
        uri.query = self.parameters.to_query
        uri
      end

      
    end
  end
end