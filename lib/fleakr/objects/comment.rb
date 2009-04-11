module Fleakr
  module Objects

    class Comment
      
      include Fleakr::Support::Object
      
      find_all :by_photo_id, :call => 'photos.comments.getList', :path => 'comments/comment'
      find_all :by_photoset_id, :call => 'photosets.comments.getList', :path => 'comments/comment'
      
      flickr_attribute :id
      flickr_attribute :author_id, :from => '@author'
      flickr_attribute :created, :from => '@datecreate'
      flickr_attribute :url, :from => '@permalink'
      flickr_attribute :body, :from => '.'
      
      def author
        @author ||= User.find_by_id(author_id)
      end
      
      def created_at
        Time.at(created.to_i)
      end
      
      def to_s
        body
      end
      
    end
    
  end
end