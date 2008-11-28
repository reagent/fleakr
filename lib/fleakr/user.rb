module Fleakr
  class User
    
    attr_accessor :nsid, :username, :id
    
    def self.find_by_username(username)
      request = Request.new('people.findByUsername', :username => username)
      response = request.send
      
      User.new(response.values_for(:user))
    end
    
    def initialize(attributes = {})
      self.set_attributes(attributes)
    end
    
    def set_attributes(attributes)
      attributes.each do |attribute, value|
        method_name = "#{attribute}=".to_sym
        self.send(method_name, value) if self.respond_to?(method_name)
      end
    end
    
  end
end