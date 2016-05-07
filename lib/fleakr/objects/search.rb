module Fleakr
  module Objects # :nodoc:
    class Search

      # attr_reader :search_options

      # Create a new search
      def initialize(*parameters)
        @parameters = Hash.new
        parameters.each {|param| add_parameter(param) }
      end

      def add_parameter(parameter)
        value = parameter.is_a?(String) ? {:text => parameter} : parameter
        @parameters.merge!(value)
      end

      def tags
        Array(@parameters[:tags])
      end

      # Retrieve search results from the API
      def results
        @results ||= begin
          response = Fleakr::Api::MethodRequest.with_response!('photos.search', parameters)
          photos = (response.body/'rsp/photos/photo').map { |p| Photo.new(p) }
          photos.extend Fleakr::Support::ResultArray
          photos.attributes = (response.body/'rsp/photos').first.attributes
          photos
        end
      end

      private
      def tag_list
        tags.join(',')
      end

      def parameters
        @parameters.merge!(:tags => tag_list) if tags.any?
        @parameters
      end

    end
  end
end
