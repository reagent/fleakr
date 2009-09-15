module Fleakr
  module Objects # :nodoc:
    
    # = User
    #
    # == Accessors
    # 
    # This class maps directly onto the flickr.people.* API methods and provides the following attributes
    # for a user:
    #
    # [id] The ID for this user (also referred to as the NSID in the API docs)
    # [username] This user's username
    # [name] This user's full name (if entered)
    # [location] This user's location (if entered)
    # [photos_url] The direct URL to this user's photostream
    # [profile_url] The direct URL to this user's profile
    # [photos_count] The number of photos that this user has uploaded
    # [icon_url] This user's buddy icon (or a default one if an icon wasn't uploaded)
    # [pro?] Does this user have a pro account?
    # [admin?] Is this user an admin?
    #
    # == Associations
    #
    # The User class is pretty central to many of the other data available across the system, so there are a
    # few associations available to a user:
    # 
    # [sets] A list of this user's public sets (newest first). See Fleakr::Objects::Set for more information.
    # [groups] A list of this user's public groups. See Fleakr::Objects::Group.
    # [photos] A list of this user's public photos (newest first).  See Fleakr::Objects::Photo.
    # [contacts] A list of this user's contacts - these are simply User objects
    # [tags] The tags associated with this user
    # [collections] The top-level collections that this user has created. See Fleakr::Objects::Collection.
    #
    # == Examples
    #
    # Access to a specific user is typically done through the Fleakr.user method:
    #
    #  user = Fleakr.user('brownout')
    #  user.id
    #  user.username
    #  user.sets
    #  user.contacts
    #
    class User

      include Fleakr::Support::Object

      flickr_attribute :id, :from => ['user@id', 'user@nsid']
      flickr_attribute :username, :location
      flickr_attribute :name, :from => 'person/realname'
      flickr_attribute :photos_url, :from => 'person/photosurl'
      flickr_attribute :profile_url, :from => 'person/profileurl'
      flickr_attribute :photos_count, :from => 'person/photos/count'
      flickr_attribute :icon_server, :from => 'person@iconserver'
      flickr_attribute :icon_farm, :from => 'person@iconfarm'
      flickr_attribute :pro, :from => 'person@ispro'
      flickr_attribute :admin, :from => 'person@isadmin'

      has_many :sets, :groups, :photos, :contacts, :tags, :collections

      find_one :by_username, :call => 'people.findByUsername'
      find_one :by_email, :using => :find_email, :call => 'people.findByEmail'
      find_one :by_id, :using => :user_id, :call => 'people.getInfo'
      find_one :by_url, :call => 'urls.lookupUser'

      lazily_load :name, :photos_url, :profile_url, :photos_count, :location, :with => :load_info
      lazily_load :icon_server, :icon_farm, :pro, :admin, :with => :load_info

      scoped_search
      
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
        response = Fleakr::Api::MethodRequest.with_response!('people.getInfo', :user_id => self.id)
        self.populate_from(response.body)
      end

    end
  end
end