module Fleakr
  module Objects # :nodoc:

    # = Tag
    #
    # This class represents a tag that can be associated with a photo or an individual user.
    #
    # == Attributes
    #
    # [id] The unique identifier for this tag
    # [raw] The raw, user-entered value for this tag
    # [value] The formatted value for this tag. Also available through <tt>to_s</tt>
    #
    class Tag
      
      include Fleakr::Support::Object
      
      flickr_attribute :id, :raw
      flickr_attribute :author_id, :from => '@author'
      flickr_attribute :value, :from => '.' # pull this from the current node
      flickr_attribute :machine_flag, :from => '@machine_tag'
      
      find_all :by_photo_id, :call => 'tags.getListPhoto', :path => 'photo/tags/tag'
      find_all :by_user_id, :call => 'tags.getListUser', :path => 'who/tags/tag'
      
      # The first user who created this tag.  See Fleakr::Objects::User for more information
      #
      def author
        @author ||= User.find_by_id(author_id) unless author_id.nil?
      end
      
      # A list of related tags.  Each of the objects in the collection is an instance of Tag
      #
      def related
        @related ||= begin
          response = Fleakr::Api::MethodRequest.with_response!('tags.getRelated', :tag => value)
          (response.body/'rsp/tags/tag').map {|e| Tag.new(e) }
        end
      end
      
      # Is this a machine tag?
      #
      def machine?
        machine_flag != '0'
      end
      
      # The formatted value of the tag.  Also available as <tt>value</tt>
      #
      def to_s
        value
      end
      
    end
    
  end
end