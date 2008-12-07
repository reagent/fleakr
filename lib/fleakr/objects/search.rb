module Fleakr
  module Objects # :nodoc:
    class Search

      # Create a new search
      def initialize(text = nil, search_options = {})
        @text = text
        @search_options = search_options
      end

      # Retrieve search results from the API
      def results
        if @results.nil?
          response = Fleakr::Api::Request.with_response!('photos.search', parameters)
          @results = (response.body/'rsp/photos/photo').map do |flickr_photo|
            Photo.new(flickr_photo)
          end
        end
        @results
      end

      private
      def tag_list
        Array(@search_options[:tags]).join(',')
      end

      def parameters
        parameters = {}
        parameters.merge!(:text => @text) if @text
        parameters.merge!(:tags => tag_list) if tag_list.length > 0
        parameters
      end

    end
  end
end