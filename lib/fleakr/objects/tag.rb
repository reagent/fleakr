module Fleakr
  module Objects # :nodoc:
    
    class Tag
      
      include Fleakr::Support::Object
      
      flickr_attribute :id
      flickr_attribute :author_id, :from => '@author'
      flickr_attribute :value, :from => '.' # pull this from the current node
      
      find_all :by_photo_id, :call => 'tags.getListPhoto', :path => 'photo/tags/tag'
      
      def author
        @author ||= User.find_by_id(author_id) unless author_id.nil?
      end
      
      def related
        response = Fleakr::Api::MethodRequest.with_response!('tags.getRelated', :tag => value)
        (response.body/'rsp/tags/tag').map {|e| Tag.new(e) }
      end
      
      def to_s
        value
      end
      
    end
    
  end
end