module Fleakr
  module Objects

    class MetadataCollection

      include Enumerable

      attr_reader :photo, :authentication_options

      def initialize(photo, authentication_options = {})
        @photo                  = photo
        @authentication_options = authentication_options
      end

      def data
        @data ||= begin
          elements = Metadata.find_all_by_photo_id(photo.id, authentication_options)
          elements.inject({}) {|c, e| c.merge(e.label => e) }
        end
      end

      def keys
        data.keys
      end

      def [](key)
        data[key].raw
      end

      def each(&block)
        data.each(&block)
      end

    end

  end
end