module Fleakr
  module Support # :nodoc:all

    class UrlExpander

      def self.expand(url)
        new(url).expanded_path
      end

      def initialize(source_url)
        @source_url = source_url
      end

      def path_to_expand
        "/photo.gne?short=#{short_photo_id}"
      end

      def expanded_path
        response_headers['location']
      end

      private

      def response_headers
        response = nil
        Net::HTTP.start('www.flickr.com', 80) {|c| response = c.head(path_to_expand) }
        response
      end

      def short_photo_id
        @source_url.match(%r{([^/]+)$})[1]
      end

    end

  end
end