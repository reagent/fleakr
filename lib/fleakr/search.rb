module Fleakr
  class Search
    
    attr_reader :tags
    
    def initialize(parameters)
      @tags = parameters[:tags]
    end
    
    def results
      response = Request.with_response!('photos.search', :tags => self.tags.join(','))
      (response.body/'rsp/photos/photo').map do |flickr_photo|
        Photo.new(flickr_photo)
      end
    end
    
  end
end