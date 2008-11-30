module Fleakr
  class User
    
    include Fleakr::Object
    
    flickr_attribute :id, :from => 'rsp/user', :attribute => 'nsid'
    flickr_attribute :username, :from => 'rsp/user/username'
    
    def self.find_by_username(username)
      response = Request.with_response!('people.findByUsername', :username => username)
      User.new(response.body)
    end
    
    def sets
      @set ||= Set.find_all_by_user_id(self.id)
    end
    
  end
end