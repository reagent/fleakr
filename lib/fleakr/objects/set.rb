module Fleakr
  module Objects # :nodoc:
    
    # = Set
    #
    # == Attributes
    # 
    # [id] The ID for this photoset
    # [title] The title of this photoset
    # [description] The description of this set
    # [count] Count of photos in this set
    # 
    # == Associations
    # 
    # [photos] The collection of photos for this set. See Fleakr::Objects::Photo
    #
    class Set

      include Fleakr::Support::Object

      has_many :photos, :using => :photoset_id

      flickr_attribute :id
      flickr_attribute :title
      flickr_attribute :description
      flickr_attribute :count, :from => '@photos'

      find_all :by_user_id, :call => 'photosets.getList', :path => 'photosets/photoset'

      # Save all photos in this set to the specified directory for the specified size.  Allowed
      # Sizes include <tt>:square</tt>, <tt>:small</tt>, <tt>:thumbnail</tt>, <tt>:medium</tt>,  
      # <tt>:large</tt>, and <tt>:original</tt>.  When saving the set, this method will create 
      # a subdirectory based on the set's title.
      #
      def save_to(path, size)
        target = "#{path}/#{self.title}"
        FileUtils.mkdir(target) unless File.exist?(target)

        self.photos.each_with_index do |photo, index|
          image = photo.send(size)
          image.save_to(target, file_prefix(index)) unless image.nil?
        end
      end
      
      def file_prefix(index) # :nodoc:
        sprintf("%0#{self.count.length}d_", (index + 1))
      end

    end
  end
end