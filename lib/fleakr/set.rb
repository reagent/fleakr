module Fleakr
  class Set
    
    attr_accessor :title, :description
    
    def self.find_all_by_user_id(user_id)
      response = Request.new('photosets.getList', :user_id => user_id).send
      
      (response.body/'photosets/photoset').map do |flickr_set|
        set = Set.new
        set.title = (flickr_set/'title').inner_text
        set.description = (flickr_set/'description').inner_text
        set
      end

    end
    
  end
end