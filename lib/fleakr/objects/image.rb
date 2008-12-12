module Fleakr
  module Objects
    
    # = Image
    #
    # This class wraps the functionality for saving remote images to disk. It's called
    # by the Fleakr::Objects::Photo class to save an image with a specific size and would 
    # typically never be called directly.
    # 
    # Example:
    # 
    #  user = Fleakr.user('brownout')
    #  user.photos.first.small.save_to('/tmp')
    #
    class Image

      include Fleakr::Support::Object

      flickr_attribute :size,   :attribute => :label
      flickr_attribute :width,  :attribute => :width
      flickr_attribute :height, :attribute => :height
      flickr_attribute :url,    :attribute => :source
      flickr_attribute :page,   :attribute => :url

      find_all :by_photo_id, :call => 'photos.getSizes', :path => 'sizes/size'

      # The filename portion of the image (without the full URL)
      def filename
        self.source.match(/([^\/]+)$/)[1]
      end
    
      # Save this image to the specified directory or file. If the target is a
      # directory, the file will be created with the original filename from Flickr.  
      # If the target is a file, it will be saved with the specified name.  In the
      # case that the target file already exists, this method will overwrite it.
      def save_to(target)
        destination = File.directory?(target) ? "#{target}/#{self.filename}" : "#{target}"
        File.open(destination, 'w') {|f| f << Net::HTTP.get(URI.parse(self.source)) }
      end
    
    end
  end
end