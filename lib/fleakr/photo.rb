module Fleakr
  class Photo

    include Fleakr::Object
    
    flickr_attribute :title, :attribute => 'title'
    
    def self.find_all_by_photoset_id(photoset_id)
      response = Request.with_response!('photosets.getPhotos', :photoset_id => photoset_id)
      (response.body/'rsp/photoset/photo').map do |photo_body|
        Photo.new(photo_body)
      end
    end
    
  end
end