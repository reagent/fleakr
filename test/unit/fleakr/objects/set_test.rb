require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class SetTest < Test::Unit::TestCase

    should_have_many :photos, :class => Photo
    should_have_many :comments, :class => Comment

    should_autoload_when_accessing :user_id, :with => :load_info

    context "The Set class" do

      should_find_all :sets, :by => :user_id, :call => 'photosets.getList', :path => 'rsp/photosets/photoset', :class => Set
      should_find_one :set, :by => :id, :with => :photoset_id, :call => 'photosets.getInfo', :path => 'rsp/photoset', :class => Set

    end

    context "An instance of the Set class" do

      context "in general" do
        setup { @set = Set.new }

        should "be able to retrieve additional information about the current set" do
          @set.stubs(:id).with().returns('1')
          response = mock_request_cycle :for => 'photosets.getInfo', :with => {:photoset_id => '1'}

          @set.stubs(:populate_from).with(response.body)

          @set.load_info
        end

        should "pass through authentication information when retrieving additional information" do
          @set.stubs(:id).with().returns('1')
          @set.stubs(:authentication_options).with().returns(:auth_token => 'toke')

          response = mock_request_cycle :for => 'photosets.getInfo', :with => {:photoset_id => '1', :auth_token => 'toke'}

          @set.stubs(:populate_from).with(response.body)

          @set.load_info
        end
      end

      context "when populating from photosets.getList" do
        setup do
          @object = Set.new(Hpricot.XML(read_fixture('photosets.getList')).at('rsp/photosets/photoset'))
        end

        should_have_a_value_for :id               => '72157609490909659'
        should_have_a_value_for :title            => 'Second Set'
        should_have_a_value_for :description      => 'This is the second set.'
        should_have_a_value_for :count            => '138'
        should_have_a_value_for :primary_photo_id => '3044180117'

      end

      context "when populating from photosets.getInfo" do
        setup do
          @object = Set.new
          @object.populate_from(Hpricot.XML(read_fixture('photosets.getInfo')))
        end

        should_have_a_value_for :user_id => '43955217@N05'
      end

      should "know the URL for the photoset" do
        s = Set.new
        s.stubs(:user_id).with().returns('123')
        s.stubs(:id).with().returns('456')

        s.url.should == "http://www.flickr.com/photos/123/sets/456/"
      end

      should "be able to retrieve the user for the set" do
        s = Set.new
        s.stubs(:user_id).with().returns('1')

        User.expects(:find_by_id).with('1', :key => 'value').returns('user')

        s.user(:key => 'value').should == 'user'
      end

      should "pass authentication options when retrieving the user for a set" do
        s = Set.new
        s.stubs(:user_id).with().returns('1')
        s.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        User.expects(:find_by_id).with('1', :key => 'value', :auth_token => 'toke').returns('user')

        s.user(:key => 'value').should == 'user'
      end

      should "know the primary photo in the set" do
        Photo.stubs(:find_by_id).with('1', {}).returns('photo')

        set = Set.new
        set.stubs(:primary_photo_id).with().returns('1')

        set.primary_photo.should == 'photo'
      end

      should "be able to pass options to the primary photo association" do
        Photo.stubs(:find_by_id).with('1', {:key => 'value'}).returns('photo')

        set = Set.new
        set.stubs(:primary_photo_id).with().returns('1')

        set.primary_photo(:key => 'value').should == 'photo'
      end

      should "be able to pass authentication options to the primary photo association" do
        Photo.stubs(:find_by_id).with('1', {:key => 'value', :auth_token => 'toke'}).returns('photo')

        set = Set.new
        set.stubs(:primary_photo_id).with().returns('1')
        set.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        set.primary_photo(:key => 'value').should == 'photo'
      end

      should "know the folder name" do
        set = Set.new
        set.stubs(:title).with().returns('Title')

        set.folder_name.should == 'Title'
      end

      should "remove forward slashes from the folder name" do
        set = Set.new
        set.stubs(:title).with().returns("This/That")

        set.folder_name.should == 'This That'
      end

      should "collapse spaces when generating the folder name" do
        set = Set.new
        set.stubs(:title).with().returns('This / That')

        set.folder_name.should == 'This That'
      end

      context "when saving the set" do
        setup do
          @tmp_dir = create_temp_directory
          @set_folder_name = 'set'

          @set = Set.new
          @set.stubs(:folder_name).with().returns(@set_folder_name)
        end

        teardown { FileUtils.rm_rf(@tmp_dir) }

        should "know the prefix string based on the number of photos in the set" do
          set = Set.new
          set.stubs(:count).with().returns('5')
          set.file_prefix(0).should == '1_'

          set.stubs(:count).with().returns('99')
          set.file_prefix(0).should == '01_'
        end

        should "save all files of the specified size to the specified directory" do
          image = mock()
          image.expects(:save_to).with("#{@tmp_dir}/set", '1_')

          photo = stub(:small => image)

          @set.stubs(:photos).with().returns([photo])
          @set.stubs(:file_prefix).with(0).returns('1_')

          FileUtils.expects(:mkdir).with("#{@tmp_dir}/set")

          @set.save_to(@tmp_dir, :small)
        end

        should "not create the directory if it already exists" do
          FileUtils.mkdir("#{@tmp_dir}/set")

          @set.stubs(:photos).with().returns([])

          FileUtils.expects(:mkdir).with("#{@tmp_dir}/set").never

          @set.save_to(@tmp_dir, :small)
        end

        should "not raise errors when saving an image size that doesn't exist" do
          @set.stubs(:photos).with().returns([stub(:large => nil)])
          lambda { @set.save_to(@tmp_dir, :large) }.should_not raise_error
        end

      end

    end

  end
end
