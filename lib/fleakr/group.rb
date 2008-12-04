module Fleakr
  class Group
    
    include Fleakr::Object
    
    flickr_attribute :id, :attribute => 'nsid'
    flickr_attribute :name, :attribute => 'name'
    
    find_all :by_user_id, :call => 'people.getPublicGroups', :path => 'groups/group'
    
  end
end