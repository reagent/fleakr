module Fleakr
  class Group
    
    include Fleakr::Object
    
    flickr_attribute :id, :attribute => 'nsid'
    flickr_attribute :name, :attribute => 'name'
    
    def self.find_all_by_user_id(user_id)
      response = Request.with_response!('people.getPublicGroups', :user_id => user_id)
      (response.body/'rsp/groups/group').map do |flickr_group|
        Group.new(flickr_group)
      end
    end
    
  end
end