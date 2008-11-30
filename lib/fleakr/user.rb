module Fleakr
  class User
    
    attr_accessor :id, :username
    
    def self.find_by_username(username)
      response = Request.with_response!('people.findByUsername', :username => username)
      
      user = User.new
      user.id = (response.body/'rsp/user').attr('id')
      user.username = (response.body/'rsp/user/username').inner_text
      
      user
    end
    
    def sets
      @set ||= Set.find_all_by_user_id(self.id)
    end
    
  end
end