module Fleakr
  module Objects # :nodoc:
    class User

      include Fleakr::Support::Object

      flickr_attribute :id, :xpath => 'rsp/user', :attribute => 'nsid'
      flickr_attribute :username, :xpath => 'rsp/user/username'
      flickr_attribute :name, :xpath => 'rsp/person/realname'
      flickr_attribute :photos_url, :xpath => 'rsp/person/photosurl'
      flickr_attribute :profile_url, :xpath => 'rsp/person/profileurl'
      flickr_attribute :photos_count, :xpath => 'rsp/person/photos/count'
      flickr_attribute :icon_server, :xpath => 'rsp/person', :attribute => 'iconserver'
      flickr_attribute :icon_farm, :xpath => 'rsp/person', :attribute => 'iconfarm'
      flickr_attribute :pro, :xpath => 'rsp/person', :attribute => 'ispro'
      flickr_attribute :admin, :xpath => 'rsp/person', :attribute => 'isadmin'

      has_many :sets, :groups, :photos, :contacts

      find_one :by_username, :call => 'people.findByUsername'
      find_one :by_email, :using => :find_email, :call => 'people.findByEmail'

      # Is this a pro account?
      def pro?
        (self.pro.to_i == 0) ? false : true
      end

      # Is this user an admin?
      def admin?
        (self.admin.to_i == 0) ? false : true
      end

      # This user's buddy icon
      def icon_url
        if self.icon_server.to_i > 0
          "http://farm#{self.icon_farm}.static.flickr.com/#{self.icon_server}/buddyicons/#{self.id}.jpg"
        else
          'http://www.flickr.com/images/buddyicon.jpg'
        end
      end
      
      def load_info # :nodoc:
        response = Fleakr::Api::Request.with_response!('people.getInfo', :user_id => self.id)
        self.populate_from(response.body)
      end

    end
  end
end