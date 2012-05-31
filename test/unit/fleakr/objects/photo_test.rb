require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class PhotoTest < Test::Unit::TestCase

    should_have_many :images, :class => Image
    should_have_many :tags, :class => Tag
    should_have_many :comments, :class => Comment

    should_autoload_when_accessing :posted, :taken, :updated, :comment_count, :with => :load_info
    should_autoload_when_accessing :url, :description, :with => :load_info

    context "The Photo class" do

      should_find_all :photos, :by => :set_id, :using => :photoset_id, :call => 'photosets.getPhotos', :path => 'rsp/photoset/photo', :class => Photo
      should_find_all :photos, :by => :group_id, :call => 'groups.pools.getPhotos', :path => 'rsp/photos/photo', :class => Photo

      should_find_all :public_photos, :method => :find_all_public_photos_by_user_id, :using => :user_id, :call => 'people.getPublicPhotos', :path => 'rsp/photos/photo', :class => Photo
      should_find_all :private_photos, :method => :find_all_private_photos_by_user_id, :using => :user_id, :call => 'people.getPhotos', :path => 'rsp/photos/photo', :class => Photo

      should_find_one :photo, :by => :id, :with => :photo_id, :call => 'photos.getInfo', :class => Photo

      # TODO: refactor these 2 tests
      should "be able to upload a photo and return the new photo information" do
        filename = '/path/to/mugshot.jpg'
        photo = stub()

        response = stub()
        response.stubs(:body).with().returns(Hpricot.XML('<photoid>123</photoid>'))

        Fleakr::Api::UploadRequest.expects(:with_response!).with(filename, :create, {}).returns(response)
        Photo.expects(:find_by_id).with('123').returns(photo)

        Photo.upload(filename).should == photo
      end

      should "be able to pass additional options when uploading a new file" do
        filename = '/path/to/mugshot.jpg'
        photo = stub()

        response = stub()
        response.stubs(:body).with().returns(Hpricot.XML('<photoid>123</photoid>'))

        Fleakr::Api::UploadRequest.expects(:with_response!).with(filename, :create, {:title => 'foo'}).returns(response)
        Photo.expects(:find_by_id).with('123').returns(photo)

        Photo.upload(filename, :title => 'foo').should == photo
      end

    end

    context "An instance of the Photo class" do

      should "be able to replace the associated photo data" do
        filename = '/path/to/file.jpg'
        response = stub(:body => 'body')

        params = {:photo_id => '1'}

        Fleakr::Api::UploadRequest.expects(:with_response!).with(filename, :update, params).returns(response)

        photo = Photo.new
        photo.stubs(:id).returns('1')
        photo.expects(:populate_from).with('body').returns(photo)

        photo.replace_with(filename).should == photo
      end

      should "pass through authentication options when replacing a photo" do
        filename = '/path/to/file.jpg'
        response = stub(:body => 'body')

        params = {:photo_id => '1', :auth_token => 'toke'}

        Fleakr::Api::UploadRequest.expects(:with_response!).with(filename, :update, params).returns(response)

        photo = Photo.new
        photo.stubs(:id).returns('1')
        photo.expects(:populate_from).with('body').returns(photo)
        photo.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        photo.replace_with(filename).should == photo
      end

      context "when populating from the people_getPublicPhotos XML data" do
        setup do
          @object = Photo.new(Hpricot.XML(read_fixture('people.getPublicPhotos')).at('rsp/photos/photo'))
        end

        should_have_a_value_for :id        => '2924549350'
        should_have_a_value_for :title     => 'Photo #1'
        should_have_a_value_for :farm_id   => '4'
        should_have_a_value_for :server_id => '3250'
        should_have_a_value_for :secret    => 'cbc1804258'
        should_have_a_value_for :owner_id  => '21775151@N06'

      end

      context "when populating from the photo upload XML data" do
        setup do
          @object = Photo.new(Hpricot.XML('<photoid>123</photoid>'))
        end

        should_have_a_value_for :id => '123'
      end

      context "when populating from the photos_getInfo XML data" do
        setup do
          @object = Photo.new(Hpricot.XML(read_fixture('photos.getInfo')))
        end

        should_have_a_value_for :id               => '1'
        should_have_a_value_for :title            => 'Tree'
        should_have_a_value_for :description      => 'A Tree'
        should_have_a_value_for :farm_id          => '4'
        should_have_a_value_for :server_id        => '3085'
        should_have_a_value_for :owner_id         => '31066442@N69'
        should_have_a_value_for :secret           => 'secret'
        should_have_a_value_for :original_secret  => 'sekrit'
        should_have_a_value_for :posted           => '1230274722'
        should_have_a_value_for :taken            => '2008-12-25 18:26:55'
        should_have_a_value_for :updated          => '1230276652'
        should_have_a_value_for :comment_count    => '0'
        should_have_a_value_for :url              => 'http://www.flickr.com/photos/yes/1'

      end

      context "in general" do

        setup do
          @photo = Photo.new
          @time  = Time.parse('2009-08-01 00:00:00')
        end

        should "be able to retrieve additional information about the current photo" do
          photo_id = '1'
          photo = Photo.new
          photo.expects(:id).with().returns(photo_id)
          response = mock_request_cycle :for => 'photos.getInfo', :with => {:photo_id => photo_id}

          photo.expects(:populate_from).with(response.body)

          photo.load_info
        end

        should "pass through authentication information when retrieving additional information" do
          photo = Photo.new
          photo.stubs(:id).with().returns('1')
          photo.stubs(:authentication_options).with().returns(:auth_token => 'toke')

          response = mock_request_cycle :for => 'photos.getInfo', :with => {:photo_id => '1', :auth_token => 'toke'}

          photo.expects(:populate_from).with(response.body)

          photo.load_info
        end

        should "have a value for :posted_at" do
          @photo.expects(:posted).with().returns("#{@time.to_i}")
          @photo.posted_at.to_s.should == @time.to_s
        end

        should "have a value for :taken_at" do
          @photo.expects(:taken).with().returns(@time.strftime('%Y-%m-%d %H:%M:%S'))
          @photo.taken_at.to_s.should == @time.to_s
        end

        should "have a value for :updated_at" do
          @photo.expects(:updated).with().returns("#{@time.to_i}")
          @photo.updated_at.to_s.should == @time.to_s
        end

        should "be able to retrieve the metadata" do
          MetadataCollection.expects(:new).with(@photo, {}).returns('metadata')
          @photo.metadata.should == 'metadata'
        end

        should "pass authentication options through to the metadata collection" do
          @photo.stubs(:authentication_options).with().returns(:auth_token => 'toke')
          MetadataCollection.expects(:new).with(@photo, :auth_token => 'toke').returns('metadata')

          @photo.metadata.should == 'metadata'
        end

        should "have a collection of images by size" do
          photo = Photo.new

          small_image, large_image, large_1600_image = [stub(:size => 'Small'), stub(:size => 'Large'), stub(:size => 'Large 1600')]

          photo.stubs(:images).returns([small_image, large_image, large_1600_image])

          expected = {
            :square       => nil,
            :large_square => nil,
            :thumbnail    => nil,
            :small        => small_image,
            :small_320    => nil,
            :medium       => nil,
            :medium_640   => nil,
            :medium_800   => nil,
            :large        => large_image,
            :large_1600   => large_1600_image,
            :large_2048   => nil,
            :original     => nil
          }

          photo.send(:images_by_size).should == expected
        end

        [:square, :thumbnail, :small, :medium, :large, :original].each do |method|
          should "have a reader for the :#{method} image" do
            photo = Photo.new
            image = stub()

            photo.stubs(:images_by_size).returns(method => image)
            photo.send(method).should == image
          end
        end

        should "be able to retrieve the context for this photo" do
          photo = Photo.new
          photo.stubs(:id).with().returns('1')

          response = mock_request_cycle :for => 'photos.getContext', :with => {:photo_id => '1'}
          PhotoContext.stubs(:new).with(response.body, {}).returns('context')

          photo.context.should == 'context'
        end

        should "pass authentication options through when retrieving the context for this photo" do
          photo = Photo.new
          photo.stubs(:id).with().returns('1')
          photo.stubs(:authentication_options).with().returns(:auth_token => 'toke')

          response = mock_request_cycle :for => 'photos.getContext', :with => {:photo_id => '1', :auth_token => 'toke'}
          PhotoContext.stubs(:new).with(response.body, :auth_token => 'toke').returns('context')

          photo.context.should == 'context'
        end

        should "be able to retrieve the next photo" do
          next_photo = stub()
          context = mock()
          context.stubs(:next).with().returns(next_photo)

          photo = Photo.new

          photo.stubs(:context).with().returns(context)

          photo.next.should == next_photo
        end

        should "be able to retrieve the previous photo" do
          previous_photo = stub()
          context = mock()
          context.stubs(:previous).with().returns(previous_photo)

          photo = Photo.new
          photo.stubs(:context).with().returns(context)

          photo.previous.should == previous_photo
        end

        should "be able to find the owner of the photo" do
          photo = Photo.new
          photo.stubs(:owner_id).with().returns('1')

          User.stubs(:find_by_id).with('1', {}).returns('owner')

          photo.owner.should == 'owner'
        end

        should "be able to pass options through to the owner association" do
          photo = Photo.new
          photo.stubs(:owner_id).with().returns('1')

          User.stubs(:find_by_id).with('1', :key => 'value').returns('owner')

          photo.owner(:key => 'value').should == 'owner'
        end

        should "pass authentication options through to the owner association" do
          photo = Photo.new
          photo.stubs(:owner_id).with().returns('1')
          photo.stubs(:authentication_options).with().returns(:auth_token => 'toke')

          User.stubs(:find_by_id).with('1', :auth_token => 'toke', :key => 'value').returns('owner')

          photo.owner(:key => 'value').should == 'owner'
        end

      end
    end

  end

end