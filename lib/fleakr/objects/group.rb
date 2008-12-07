module Fleakr
  module Objects # :nodoc:
    
    # = Group
    # 
    # == Accessors
    #
    # [id] This group's ID
    # [name] The name of the group
    #
    class Group

      include Fleakr::Support::Object

      flickr_attribute :id, :attribute => 'nsid'
      flickr_attribute :name, :attribute => 'name'

      find_all :by_user_id, :call => 'people.getPublicGroups', :path => 'groups/group'

    end
  end
end