module Fleakr
  class Photo

    include Fleakr::Object
    
    flickr_attribute :title, :attribute => 'title'
    flickr_attribute :id, :attribute => 'id'
    
    def self.find_all_by_photoset_id(photoset_id)
      response = Request.with_response!('photosets.getPhotos', :photoset_id => photoset_id)
      (response.body/'rsp/photoset/photo').map {|p| Photo.new(p) }
    end
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('people.getPublicPhotos', :user_id => user_id)
      (response.body/'rsp/photos/photo').map {|p| Photo.new(p) }
    end
    
  end
end