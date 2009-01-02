module Fleakr
  module Objects # :nodoc:
    class Search

      # Create a new search
      def initialize(search_options)
        @search_options = search_options
      end

      # Retrieve search results from the API
      def results
        @results ||= begin
          response = Fleakr::Api::MethodRequest.with_response!('photos.search', parameters)
          (response.body/'rsp/photos/photo').map {|p| Photo.new(p) }
        end
      end

      private
      def tag_list
        Array(@search_options[:tags]).join(',')
      end

      def parameters
        @search_options.merge!(:tags => tag_list) if tag_list.length > 0
        @search_options
      end

    end
  end
end