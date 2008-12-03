module Fleakr
  class Photo

    include Fleakr::Object
    
    flickr_attribute :title, :attribute => 'title'
    flickr_attribute :id, :attribute => 'id'
    
    def self.find_all_by_photoset_id(photoset_id)
      response = Request.with_response!('photosets.getPhotos', :photoset_id => photoset_id)
      (response.body/'rsp/photoset/photo').map do |photo_body|
        Photo.new(photo_body)
      end
    end
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('people.getPublicPhotos', :user_id => user_id)
      (response.body/'rsp/photos/photo').map do |flickr_photo|
        Photo.new(flickr_photo)
      end
    end
    
  end
end