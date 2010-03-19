module Fleakr
  module Objects
    
    # = Exif
    #
    # This class wraps the functionality of EXIF data extraction. It's called
    # by the Fleakr::Objects::Photo class to obtain EXIF values
    # 
    # Example:
    # 
    #  user = Fleakr.user('brownout')
    #  user.photos.first.exifs
    #
    # == Attributes
    # 
    # [raw] The raw value returned by Flickr (e.g. 1/500 for ExposureTime)
    # [clean] The clean value returned by Flickr for the tag (e.g. 0.0.02 (1/500) for ExposureTime)
    # [tagspace] The tag space of the EXIF data, (e.g. TIFF, ExifIFD, Composite)
    # [tag] The label as a tag, (e.g. ExposureProgram)
    # [label] The label for the tag, (e.g. 'Exposure Program')
    # 
    class Exif

      include Fleakr::Support::Object

      flickr_attribute :tagspace, :tag, :label
      flickr_attribute :raw, :from => 'raw'
      flickr_attribute :clean, :from => 'clean'

      find_all :by_photo_id, :call => 'photos.getExif', :path => 'photo/exif'
      
     
    
    end
  end
end