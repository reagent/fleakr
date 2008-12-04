module Fleakr
  class Set

    include Fleakr::Object

    has_many :photos, :using => :photoset_id
    
    flickr_attribute :id, :attribute => 'id'
    flickr_attribute :title
    flickr_attribute :description
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('photosets.getList', :user_id => user_id)
      (response.body/'rsp/photosets/photoset').map {|s| Set.new(s) }
    end
    
    def save_to(path, size)
      target = "#{path}/#{self.title}"
      FileUtils.mkdir(target) unless File.exist?(target)
      
      self.photos.each {|p| p.send(size).save_to(target) }
    end
    
  end
end