module Fleakr
  class Photo

    include Fleakr::Object
    
    flickr_attribute :title, :attribute => 'title'
    flickr_attribute :id, :attribute => 'id'
    flickr_attribute :farm_id, :attribute => 'farm'
    flickr_attribute :server_id, :attribute => 'server'
    flickr_attribute :secret, :attribute => 'secret'
    
    finder :multiple, :using => :photoset_id, :call => 'photosets.getPhotos', :path => 'photoset/photo'
    finder :multiple, :using => :user_id, :call => 'people.getPublicPhotos', :path => 'photos/photo'
    
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