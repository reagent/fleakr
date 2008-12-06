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
    
      # Retrieve the URL for this image using the specified size
      def url
        "#{@base_url}#{Image.suffix_for(@size)}"
      end
    
      # The filename portion of the image (without the full URL)
      def filename
        self.url.match(/([^\/]+)$/)[1]
      end
    
      # Save this image to the specified directory or file. If the target is a
      # directory, the file will be created with the original filename from Flickr.  
      # If the target is a file, it will be saved with the specified name.  In the
      # case that the target file already exists, this method will overwrite it.
      def save_to(target)
        destination = File.directory?(target) ? "#{target}/#{self.filename}" : "#{target}"
        File.open(destination, 'w') {|f| f << Net::HTTP.get(URI.parse(self.url)) }
      end
    
    end
  end
end