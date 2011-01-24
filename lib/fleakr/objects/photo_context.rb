module Fleakr
  module Objects # :nodoc:

    # = PhotoContext
    #
    # This class represents the context for a photo as retrieved from the API.  It's not
    # intended to be used directly, but is used in conjunction with Photo#previous and
    # Photo#next
    #
    # == Attributes
    #
    # [count] The number of photos available

    class PhotoContext

      include Fleakr::Support::Object

      flickr_attribute :count
      flickr_attribute :next_id,     :from => 'nextphoto@id'
      flickr_attribute :previous_id, :from => 'prevphoto@id'

      # Is there a previous photo available for the current photo?
      #
      def previous?
        previous_id != '0'
      end

      # The previous photo if one is available
      #
      def previous
        with_caching(authentication_options, 'previous') do
          Photo.find_by_id(previous_id, authentication_options) if previous?
        end
      end

      # Is there a next photo available for the current photo?
      #
      def next?
        next_id != '0'
      end

      # The next photo if one is available
      #
      def next
        with_caching(authentication_options, 'next') do
          Photo.find_by_id(next_id, authentication_options) if next?
        end
      end

    end

  end
end