module Fleakr
  module Objects
    class Group

      include Fleakr::Support::Object

      flickr_attribute :id, :attribute => 'nsid'
      flickr_attribute :name, :attribute => 'name'

      find_all :by_user_id, :call => 'people.getPublicGroups', :path => 'groups/group'

    end
  end
end