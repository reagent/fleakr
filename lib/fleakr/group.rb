module Fleakr
  class Group
    
    include Fleakr::Object
    
    flickr_attribute :id, :attribute => 'nsid'
    flickr_attribute :name, :attribute => 'name'
    
    finder :multiple, :using => :user_id, :call => 'people.getPublicGroups', :path => 'groups/group'
    
  end
end