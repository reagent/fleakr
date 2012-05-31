module Fleakr
  module Objects # :nodoc:

    # = Photo
    #
    # Handles both the retrieval of Photo objects from various associations (e.g. User / Set) as
    # well as the ability to upload images to the Flickr site.
    #
    # == Attributes
    #
    # [id] The ID for this photo
    # [title] The title of this photo
    # [description] The description of this photo
    # [secret] This photo's secret (used for sharing photo without permissions checking)
    # [original_secret] This photo's original secret
    # [comment_count] Count of the comments attached to this photo
    # [url] This photo's page on Flickr
    # [square] The tiny square representation of this photo
    # [thumbnail] The thumbnail for this photo
    # [small] The small representation of this photo
    # [medium] The medium representation of this photo
    # [large] The large representation of this photo
    # [original] The original photo
    # [previous] The previous photo based on the current context
    # [next] The next photo based on the current context
    #
    # == Associations
    #
    # [images] The underlying images for this photo.
    # [tags] The tags for this photo.
    # [comments] The comments associated with this photo
    #
    class Photo

      # Available sizes for this photo
      SIZES = [:square, :large_square, :thumbnail, :small, :small_320, :medium, :medium_640, :medium_800, :large, :large_1600, :large_2048, :original]

      include Fleakr::Support::Object
      extend Forwardable

      def_delegators :context, :next, :previous

      flickr_attribute :id, :from => ['@id', 'photoid']
      flickr_attribute :title, :description, :secret, :posted, :taken, :url
      flickr_attribute :farm_id, :from => '@farm'
      flickr_attribute :server_id, :from => '@server'
      flickr_attribute :owner_id, :from => ['@owner', 'owner@nsid']
      flickr_attribute :updated, :from => '@lastupdate'
      flickr_attribute :comment_count, :from => 'comments'
      flickr_attribute :original_secret, :from => '@originalsecret'

      # TODO:
      # * visibility
      # * editability
      # * usage

      find_all :by_set_id, :using => :photoset_id, :call => 'photosets.getPhotos', :path => 'photoset/photo'
      find_all :by_group_id, :call => 'groups.pools.getPhotos', :path => 'photos/photo'

      find_all :public_photos_by_user_id, :call => 'people.getPublicPhotos', :path => 'photos/photo', :using => :user_id
      find_all :private_photos_by_user_id, :call => 'people.getPhotos', :path => 'photos/photo', :using => :user_id

      find_one :by_id, :using => :photo_id, :call => 'photos.getInfo'

      lazily_load :posted, :taken, :updated, :comment_count, :url, :description, :with => :load_info

      has_many :images, :tags, :comments

      # Upload the photo specified by <tt>filename</tt> to the user's Flickr account. When uploading,
      # there are several options available (none are required):
      #
      # [:title] The title for this photo. Any string is allowed.
      # [:description] The description for this photo. Any string is allowed.
      # [:tags] A collection of tags for this photo. This can be a string or array of strings.
      # [:viewable_by] Who can view this photo?  Acceptable values are one of <tt>:everyone</tt>,
      #                <tt>:friends</tt> or <tt>:family</tt>.  This can also take an array of values
      #                (e.g. <tt>[:friends, :family]</tt>) to make it viewable by friends and family.
      # [:level] The safety level of this photo.  Acceptable values are one of <tt>:safe</tt>,
      #          <tt>:moderate</tt>, or <tt>:restricted</tt>.
      # [:type] The type of image this is.  Acceptable values are one of <tt>:photo</tt>,
      #         <tt>:screenshot</tt>, or <tt>:other</tt>.
      # [:hide?] Should this photo be hidden from public searches? Takes a boolean.
      #
      def self.upload(filename, options = {})
        response = Fleakr::Api::UploadRequest.with_response!(filename, :create, options)
        photo = Photo.new(response.body)
        Photo.find_by_id(photo.id)
      end

      def metadata
        @metadata ||= MetadataCollection.new(self, authentication_options)
      end

      # Replace the current photo's image with the one specified by filename.  This
      # call requires authentication.
      #
      def replace_with(filename)
        options  = authentication_options.merge(:photo_id => id)
        response = Fleakr::Api::UploadRequest.with_response!(filename, :update, options)

        populate_from(response.body)
      end

      # TODO: Refactor this to remove duplication w/ User#load_info - possibly in the lazily_load class method
      def load_info # :nodoc:
        options  = authentication_options.merge(:photo_id => id)
        response = Fleakr::Api::MethodRequest.with_response!('photos.getInfo', options)

        populate_from(response.body)
      end

      def context # :nodoc:
        @context ||= begin
          options  = authentication_options.merge(:photo_id => id)
          response = Fleakr::Api::MethodRequest.with_response!('photos.getContext', options)

          PhotoContext.new(response.body, authentication_options)
        end
      end

      # The user who uploaded this photo.  See Fleakr::Objects::User for additional information.
      #
      def owner(options = {})
        with_caching(options, 'owner') do
          User.find_by_id(owner_id, authentication_options.merge(options))
        end
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
        images.inject(image_sizes) {|l,o| l.merge!(o.size.downcase.gsub(" ", "_").to_sym => o) }
      end

    end
  end
end