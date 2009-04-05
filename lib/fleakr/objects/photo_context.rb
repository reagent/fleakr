module Fleakr
  module Objects # :nodoc:
    
    class PhotoContext
      
      include Fleakr::Support::Object
      
      flickr_attribute :count
      flickr_attribute :next_id,     :from => 'nextphoto@id'
      flickr_attribute :previous_id, :from => 'prevphoto@id'
      
      def previous?
        previous_id != '0'
      end
      
      def previous
        Photo.find_by_id(previous_id) if previous?
      end
      
      def next?
        next_id != '0'
      end
      
      def next
        Photo.find_by_id(next_id) if next?
      end
      
    end
    
  end
end