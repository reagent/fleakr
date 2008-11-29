module Fleakr
  class User
    
    attr_accessor :id, :username
    
    def self.find_by_username(username)
      response = Fleakr::Request.new('people.findByUsername', :username => username).send
      
      user = User.new
      user.id = (response.body/'rsp/user').attr('id')
      user.username = (response.body/'rsp/user/username').inner_text
      
      user
    end
    
  end
end