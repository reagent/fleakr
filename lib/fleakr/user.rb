module Fleakr
  class User

    include Fleakr::Object

    flickr_attribute :id, :xpath => 'rsp/user', :attribute => 'nsid'
    flickr_attribute :username, :xpath => 'rsp/user/username'
    flickr_attribute :photos_url, :xpath => 'rsp/person/photosurl'
    flickr_attribute :profile_url, :xpath => 'rsp/person/profileurl'
    flickr_attribute :photos_count, :xpath => 'rsp/person/photos/count'
    flickr_attribute :icon_server, :xpath => 'rsp/person', :attribute => 'iconserver'
    flickr_attribute :icon_farm, :xpath => 'rsp/person', :attribute => 'iconfarm'
    
    has_many :sets, :groups, :photos, :contacts
    
    find_one :by_username, :call => 'people.findByUsername'
    find_one :by_email, :using => :find_email, :call => 'people.findByEmail'

    def load_info
      response = Request.with_response!('people.getInfo', :user_id => self.id)
      self.populate_from(response.body)
    end

    def icon_url
      if self.icon_server.to_i > 0
        "http://farm#{self.icon_farm}.static.flickr.com/#{self.icon_server}/buddyicons/#{self.id}.jpg"
      else
        'http://www.flickr.com/images/buddyicon.jpg'
      end
    end

  end
end