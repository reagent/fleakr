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
    # == Attributes
    # 
    # [size] The name of this image's size (e.g. Square, Large, etc...)
    # [width] The width of this image
    # [height] The height of this image
    # [url] The direct URL for this image
    # [page] The page on Flickr that represents this photo
    # 
    class Image

      include Fleakr::Support::Object

      flickr_attribute :width, :height
      flickr_attribute :size,   :from => '@label'
      flickr_attribute :url,    :from => '@source'
      flickr_attribute :page,   :from => '@url'

      find_all :by_photo_id, :call => 'photos.getSizes', :path => 'sizes/size'

      # The filename portion of the image (without the full URL)
      def filename
        self.url.match(/([^\/]+)$/)[1]
      end
    
      # Save this image to the specified directory or file. If the target is a
      # directory, the file will be created with the original filename from Flickr.  
      # If the target is a file, it will be saved with the specified name.  In the
      # case that the target file already exists, this method will overwrite it.
      def save_to(target, prefix = nil)
        destination = File.directory?(target) ? "#{target}/#{prefix}#{self.filename}" : "#{target}"
        File.open(destination, 'w') {|f| f << Net::HTTP.get(URI.parse(self.url)) }
      end
    
    end
  end
end