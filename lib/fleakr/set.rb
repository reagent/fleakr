module Fleakr
  class Set
    
    attr_accessor :id, :title, :description
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('photosets.getList', :user_id => user_id)
      
      (response.body/'rsp/photosets/photoset').map do |flickr_set|
        set = Set.new
        set.id = (flickr_set).attributes['id']
        set.title = (flickr_set/'title').inner_text
        set.description = (flickr_set/'description').inner_text
        set
      end

    end
    
    def photos
      @photos ||= Photo.find_all_by_photoset_id(self.id)
    end
    
  end
end