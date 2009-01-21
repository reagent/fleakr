module Fleakr
  module Objects # :nodoc:
    
    # = Photo
    #
    # == Attributes
    #
    # [id] The ID for this photo
    # [title] The title of this photo
    # [description] The description of this photo
    # [secret] This photo's secret (used for sharing photo without permissions checking)
    # [comment_count] Count of the comments attached to this photo
    # [url] This photo's page on Flickr
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

      flickr_attribute :id, :from => ['@id', 'photoid']
      flickr_attribute :title
      flickr_attribute :description
      flickr_attribute :farm_id, :from => '@farm'
      flickr_attribute :server_id, :from => '@server'
      flickr_attribute :secret
      flickr_attribute :posted
      flickr_attribute :taken
      flickr_attribute :updated, :from => '@lastupdate'
      flickr_attribute :comment_count, :from => 'comments'
      flickr_attribute :url

      # TODO:
      # * owner (user)
      # * visibility
      # * editability
      # * usage
      # * notes
      # * tags

      find_all :by_photoset_id, :call => 'photosets.getPhotos', :path => 'photoset/photo'
      find_all :by_user_id, :call => 'people.getPublicPhotos', :path => 'photos/photo'
      find_all :by_group_id, :call => 'groups.pools.getPhotos', :path => 'photos/photo'
      
      find_one :by_id, :using => :photo_id, :call => 'photos.getInfo'
      
      lazily_load :posted, :taken, :updated, :comment_count, :url, :description, :with => :load_info
      
      has_many :images

      # Upload the photo specified by <tt>filename</tt> to the user's Flickr account.  This
      # call requires authentication.
      #
      def self.upload(filename)
        response = Fleakr::Api::UploadRequest.with_response!(filename)
        photo = Photo.new(response.body)
        Photo.find_by_id(photo.id, :authenticate? => true)
      end

      # Replace the current photo's image with the one specified by filename.  This 
      # call requires authentication.
      #
      def replace_with(filename)
        response = Fleakr::Api::UploadRequest.with_response!(filename, :photo_id => self.id, :type => :update)
        self.populate_from(response.body)
        self
      end

      # TODO: Refactor this to remove duplication w/ User#load_info - possibly in the lazily_load class method
      def load_info # :nodoc:
        response = Fleakr::Api::MethodRequest.with_response!('photos.getInfo', :photo_id => self.id)
        self.populate_from(response.body)
      end

      # When was this photo posted?
      #
      def posted_at
        Time.at(posted.to_i)
      end
      
      # When was this photo taken?
      #
      def taken_at
        Time.parse(taken)
      end
      
      # When was this photo last updated?  This includes addition of tags and other metadata.
      #
      def updated_at
        Time.at(updated.to_i)
      end

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