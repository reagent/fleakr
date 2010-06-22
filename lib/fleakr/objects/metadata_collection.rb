module Fleakr
  module Objects

    class MetadataCollection

      include Enumerable

      attr_reader :photo

      def initialize(photo)
        @photo = photo
      end

      def data
        @data ||= begin
          elements = Metadata.find_all_by_photo_id(photo.id)
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