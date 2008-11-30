module Fleakr
  class Photo
    
    def self.find_all_by_photoset_id(photoset_id)
      response = Request.with_response!('photosets.getPhotos', :photoset_id => photoset_id)
      (response.body/'rsp/photoset/photo').map do |photo_body|
        Photo.new(photo_body)
      end
    end
    
    def initialize(photo_body)
      @response_body = photo_body
    end
    
    def title
      (@response_body).attributes['title']
    end
    
  end
end