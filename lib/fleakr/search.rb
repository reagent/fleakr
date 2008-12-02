module Fleakr
  class Search

    attr_reader :tags

    def initialize(text = nil, search_options = {})
      @text = text
      @search_options = search_options
    end

    def tag_list
      Array(@search_options[:tags]).join(',')
    end
    
    def parameters
      parameters = {}
      parameters.merge!(:text => @text) if @text
      parameters.merge!(:tags => self.tag_list) if self.tag_list.length > 0
      parameters
    end

    def results
      if @results.nil?
        response = Request.with_response!('photos.search', self.parameters)
        @results = (response.body/'rsp/photos/photo').map do |flickr_photo|
          Photo.new(flickr_photo)
        end
      end
      @results
    end

  end
end