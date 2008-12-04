module Fleakr
  class Set

    include Fleakr::Object

    has_many :photos, :using => :photoset_id
    
    flickr_attribute :id, :attribute => 'id'
    flickr_attribute :title
    flickr_attribute :description
    
    finder :multiple, :call => 'photosets.getList', :using => :user_id, :path => 'photosets/photoset'
    
    def save_to(path, size)
      target = "#{path}/#{self.title}"
      FileUtils.mkdir(target) unless File.exist?(target)
      
      self.photos.each {|p| p.send(size).save_to(target) }
    end
    
  end
end