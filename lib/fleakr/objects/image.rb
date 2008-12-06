module Fleakr
  module Objects
    class Image

      SUFFIXES = {
        :square    => '_s.jpg',
        :thumbnail => '_t.jpg',
        :small     => '_m.jpg',
        :medium    => '.jpg',
        :large     => '_b.jpg',
      }.freeze
    
      def self.suffix_for(size)
        self::SUFFIXES[size]
      end
    
      def initialize(base_url, size)
        @base_url = base_url
        @size = size
      end
    
      def url
        "#{@base_url}#{Image.suffix_for(@size)}"
      end
    
      def filename
        self.url.match(/([^\/]+)$/)[1]
      end
    
      def save_to(target)
        destination = File.directory?(target) ? "#{target}/#{self.filename}" : "#{target}"
        File.open(destination, 'w') {|f| f << Net::HTTP.get(URI.parse(self.url)) }
      end
    
    end
  end
end