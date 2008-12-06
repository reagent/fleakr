module Fleakr
  module Objects # :nodoc:
    class Set

      include Fleakr::Support::Object

      has_many :photos, :using => :photoset_id

      flickr_attribute :id, :attribute => 'id'
      flickr_attribute :title
      flickr_attribute :description

      find_all :by_user_id, :call => 'photosets.getList', :path => 'photosets/photoset'

      # Save all photos in this set to the specified directory using the specified size.  Allowed
      # Sizes include <tt>:square</tt>, <tt>:small</tt>, <tt>:thumbnail</tt>, <tt>:medium</tt>, and 
      # <tt>:large</tt>.  When saving the set, this # method will create a subdirectory based on the 
      # set's title.
      def save_to(path, size)
        target = "#{path}/#{self.title}"
        FileUtils.mkdir(target) unless File.exist?(target)

        self.photos.each {|p| p.send(size).save_to(target) }
      end

    end
  end
end