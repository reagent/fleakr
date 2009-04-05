module Fleakr
  module Objects # :nodoc:
    
    class Tag
      
      include Fleakr::Support::Object
      
      flickr_attribute :id
      flickr_attribute :author_id, :from => '@author'
      flickr_attribute :value, :from => '.' # pull this from the current node
      
      find_all :by_photo_id, :call => 'tags.getListPhoto', :path => 'photo/tags/tag'
      
    end
    
  end
end