module Fleakr
  class Photo

    include Fleakr::Object
    
    flickr_attribute :title, :attribute => 'title'
    flickr_attribute :id, :attribute => 'id'
    flickr_attribute :farm_id, :attribute => 'farm'
    flickr_attribute :server_id, :attribute => 'server'
    flickr_attribute :secret, :attribute => 'secret'
    
    def self.find_all_by_photoset_id(photoset_id)
      response = Request.with_response!('photosets.getPhotos', :photoset_id => photoset_id)
      (response.body/'rsp/photoset/photo').map {|p| Photo.new(p) }
    end
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('people.getPublicPhotos', :user_id => user_id)
      (response.body/'rsp/photos/photo').map {|p| Photo.new(p) }
    end
    
    def base_url
      "http://farm#{self.farm_id}.static.flickr.com/#{self.server_id}/#{self.id}_#{self.secret}"
    end

    [:square, :thumbnail, :small, :medium, :large].each do |size|
      define_method(size) do
        Image.new(self.base_url, size)
      end
    end
    
  end
end