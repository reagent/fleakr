module Fleakr
  class Set

    include Fleakr::Object
    
    flickr_attribute :id, :attribute => 'id'
    flickr_attribute :title, :from => 'title'
    flickr_attribute :description, :from => 'description'
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('photosets.getList', :user_id => user_id)
      
      (response.body/'rsp/photosets/photoset').map do |flickr_set|
        Set.new(flickr_set)
      end
    end
    
    def photos
      @photos ||= Photo.find_all_by_photoset_id(self.id)
    end
    
  end
end