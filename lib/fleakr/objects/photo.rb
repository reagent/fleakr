module Fleakr
  module Objects # :nodoc:
    
    # = Photo
    #
    # == Attributes
    #
    # [id] The ID for this photo
    # [title] The title of this photo
    # [square] The tiny square representation of this photo
    # [thumbnail] The thumbnail for this photo
    # [small] The small representation of this photo
    # [medium] The medium representation of this photo
    # [large] The large representation of this photo
    # [original] The original photo
    #
    # == Associations
    #
    # [images] The underlying images for this photo.
    #
    class Photo

      # Available sizes for this photo
      SIZES = [:square, :thumbnail, :small, :medium, :large, :original]

      include Fleakr::Support::Object

      flickr_attribute :title
      flickr_attribute :id
      flickr_attribute :farm_id, :from => '@farm'
      flickr_attribute :server_id, :from => '@server'
      flickr_attribute :secret

      find_all :by_photoset_id, :call => 'photosets.getPhotos', :path => 'photoset/photo'
      find_all :by_user_id, :call => 'people.getPublicPhotos', :path => 'photos/photo'
      find_all :by_group_id, :call => 'groups.pools.getPhotos', :path => 'photos/photo'
      
      has_many :images

      # Create methods to access image sizes by name
      SIZES.each do |size|
        define_method(size) do
          images_by_size[size]
        end
      end

      private
      def images_by_size
        image_sizes = SIZES.inject({}) {|l,o| l.merge(o => nil)}
        self.images.inject(image_sizes) {|l,o| l.merge!(o.size.downcase.to_sym => o) }
      end

    end
  end
end