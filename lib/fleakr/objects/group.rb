module Fleakr
  module Objects # :nodoc:
    
    # = Group
    # 
    # == Accessors
    #
    # [id] This group's ID
    # [name] The name of the group
    #
    # == Associations
    #
    # [photos] The photos that are in this group
    #
    class Group

      include Fleakr::Support::Object

      flickr_attribute :id, :from => '@nsid'
      flickr_attribute :name
      flickr_attribute :adult_flag, :from => '@eighteenplus'

      find_all :by_user_id, :call => 'people.getPublicGroups', :path => 'groups/group'

      has_many :photos
      
      scoped_search
      
      # Is this group adult-only? (e.g. only 18+ allowed to view)
      def adult?
        (adult_flag == '1')
      end

    end
  end
end