module Fleakr
  module Objects # :nodoc:

    # = Comment
    #
    # This class represents a comment that can be associated with a single photo or an
    # entire photoset.
    #
    # == Attributes
    #
    # [id] The unique identifier for this comment
    # [url] The direct URL / permalink to reference this comment
    # [body] The comment itself - also available with <tt>to_s</tt>
    #
    class Comment
      
      include Fleakr::Support::Object
      
      find_all :by_photo_id, :call => 'photos.comments.getList', :path => 'comments/comment'
      find_all :by_set_id, :using => :photoset_id, :call => 'photosets.comments.getList', :path => 'comments/comment'
      
      flickr_attribute :id
      flickr_attribute :author_id, :from => '@author'
      flickr_attribute :created, :from => '@datecreate'
      flickr_attribute :url, :from => '@permalink'
      flickr_attribute :body, :from => '.'

      # The user who supplied the comment.  See Fleakr::Objects::User for more information
      #
      def author
        @author ||= User.find_by_id(author_id)
      end
      
      # When was this comment created?
      #
      def created_at
        Time.at(created.to_i)
      end
      
      # The contents of the comment - also available as <tt>body</tt>
      #
      def to_s
        body
      end
      
    end
    
  end
end