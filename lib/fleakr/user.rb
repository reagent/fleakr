module Fleakr
  class User
    
    attr_accessor :id, :username
    
    def self.find_by_username(username)
      response = Request.with_response!('people.findByUsername', :username => username)
      User.new(response.body)
    end
    
    # flickr_attribute :id, :from => 'user', :attribute => 'nsid'
    # flickr_attribute :username, :from => 'user/username', :text => true
    
    def initialize(response_body)
      @response_body = (response_body/'rsp')
    end
    
    def id
      (@response_body/'user').attr('id')
    end
    
    def username
      (@response_body/'user/username').inner_text
    end
    
    def sets
      @set ||= Set.find_all_by_user_id(self.id)
    end
    
  end
end