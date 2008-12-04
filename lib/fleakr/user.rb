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

    def self.find_by_username(username)
      response = Request.with_response!('people.findByUsername', :username => username)
      User.new(response.body)
    end

    def self.find_by_email(email)
      response = Request.with_response!('people.findByEmail', :find_email => email)
      User.new(response.body)
    end

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

    def sets
      @set ||= Set.find_all_by_user_id(self.id)
    end

    def groups
      @groups ||= Group.find_all_by_user_id(self.id)
    end
    
    def photos
      @photos ||= Photo.find_all_by_user_id(self.id)
    end

  end
end