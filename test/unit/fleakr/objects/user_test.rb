require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class UserTest < Test::Unit::TestCase

    should_search_by :user_id

    should_have_many :public_photos, :class => Photo, :method => :find_all_public_photos_by_user_id
    should_have_many :private_photos, :class => Photo, :method => :find_all_private_photos_by_user_id
    should_have_many :groups, :class => Group
    should_have_many :sets, :class => Set
    should_have_many :contacts, :class => Contact
    should_have_many :tags, :class => Tag
    should_have_many :collections, :class => Collection

    should_autoload_when_accessing :name, :photos_url, :profile_url, :photos_count, :location, :with => :load_info
    should_autoload_when_accessing :icon_server, :icon_farm, :pro, :admin, :icon_url, :with => :load_info

    context "The User class" do

      should_find_one :user, :by => :username, :call => 'people.findByUsername', :path => 'rsp/user', :class => User
      should_find_one :user, :by => :email, :with => :find_email, :call => 'people.findByEmail', :path => 'rsp/user', :class => User
      should_find_one :user, :by => :id, :with => :user_id, :call => 'people.getInfo', :path => 'rsp/person', :class => User
      should_find_one :user, :by => :url, :call => 'urls.lookupUser', :path => 'rsp/user', :class => User

      should "recognize a string as not being a Flickr user ID" do
        User.user_id?('reagent').should be(false)
      end

      should "recognize a string as being a Flickr user ID" do
        User.user_id?('43955217@N05').should be(true)
      end

      should "be able to find a user by ID when supplied with an identifier" do
        id = '43955217@N05'
        User.expects(:find_by_id).with(id).returns('user')

        User.find_by_identifier(id).should == 'user'
      end

      should "be able to find a user by username when supplied with an identifier" do
        username = 'reagent'
        User.expects(:find_by_username).with(username).returns('user')

        User.find_by_identifier(username).should == 'user'
      end

    end

    context "An instance of User" do
      context "when populating the object from an XML document" do
        setup do
          @object = User.new(Hpricot.XML(read_fixture('people.findByUsername')))
          @object.populate_from(Hpricot.XML(read_fixture('people.getInfo')))
        end

        should_have_a_value_for :id           => '31066442@N69'
        should_have_a_value_for :username     => 'frootpantz'
        should_have_a_value_for :name         => 'Sir Froot Pantz'
        should_have_a_value_for :location     => 'The Moon'
        should_have_a_value_for :photos_url   => 'http://www.flickr.com/photos/frootpantz/'
        should_have_a_value_for :profile_url  => 'http://www.flickr.com/people/frootpantz/'
        should_have_a_value_for :photos_count => '3907'
        should_have_a_value_for :icon_server  => '30'
        should_have_a_value_for :icon_farm    => '1'
        should_have_a_value_for :pro          => '1'
        should_have_a_value_for :admin        => '0'

      end

      context "when populating an object from the urls.lookupUser API call" do
        setup do
          document = Hpricot.XML(read_fixture('urls.lookupUser'))
          @object = User.new(document)
        end

        should_have_a_value_for :id       => '123456'
        should_have_a_value_for :username => 'frootpantz'

      end

      context "in general" do

        setup do
          @user = User.new
          @user.stubs(:id).with().returns('1')
        end

        should "know that it is not authenticated" do
          user = User.new(nil, {:foo => 'bar'})
          user.authenticated?.should be(false)
        end

        should "know that it's authenticated" do
          user = User.new(nil, {:auth_token => 'toke'})
          user.authenticated?.should be(true)
        end

        should "retrieve public photos when it's not authenticated" do
          @user.stubs(:authenticated?).with().returns(false)
          @user.stubs(:public_photos).returns('photos')

          @user.photos.should == 'photos'
        end

        should "be able to pass options through to the photos association when not authenticated" do
          @user.stubs(:authenticated?).with().returns(false)
          @user.stubs(:public_photos).with(:key => 'value').returns('photos')

          @user.photos(:key => 'value').should == 'photos'
        end

        should "retreive all photos when it's authenticated" do
          @user.stubs(:authenticated?).with().returns(true)
          @user.stubs(:private_photos).returns('photos')

          @user.photos.should == 'photos'
        end

        should "pass authentication options and additional options through to the private photos" do
          @user.stubs(:authentication_options).with().returns(:auth_token => 'toke')
          @user.stubs(:private_photos).with(:key => 'value', :auth_token => 'toke').returns('photos')

          @user.photos(:key => 'value').should == 'photos'
        end

        should "be able to retrieve additional information about the current user" do
          response = mock_request_cycle :for => 'people.getInfo', :with => {:user_id => @user.id}
          @user.expects(:populate_from).with(response.body)

          @user.load_info
        end

        should "pass authentication information when retriving information for a user" do
          @user.stubs(:authentication_options).with().returns(:auth_token => 'toke')
          response = mock_request_cycle :for => 'people.getInfo', :with => {:user_id => @user.id, :auth_token => 'toke'}
          @user.expects(:populate_from).with(response.body)

          @user.load_info
        end

        should "be able to generate an icon URL when the :icon_server value is greater than zero" do
          @user.stubs(:icon_server).with().returns('1')
          @user.stubs(:icon_farm).with().returns('2')
          @user.stubs(:id).with().returns('45')

          @user.icon_url.should == 'http://farm2.static.flickr.com/1/buddyicons/45.jpg'
        end

        should "return the default icon URL when the :icon_server value is zero" do
          @user.stubs(:icon_server).with().returns('0')
          @user.icon_url.should == 'http://www.flickr.com/images/buddyicon.jpg'
        end

        should "return the default icon URL when the :icon_server value is nil" do
          @user.stubs(:icon_server).with().returns(nil)
          @user.icon_url.should == 'http://www.flickr.com/images/buddyicon.jpg'
        end

        should "return a boolean value for :pro?" do
          @user.stubs(:pro).with().returns('0')
          @user.pro?.should be(false)

          @user.stubs(:pro).with().returns('1')
          @user.pro?.should be(true)
        end

        should "return a boolean value for :admin?" do
          @user.stubs(:admin).with().returns('0')
          @user.admin?.should be(false)

          @user.stubs(:admin).with().returns('1')
          @user.admin?.should be(true)
        end

      end
    end

  end
end