require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class UserTest < Test::Unit::TestCase

    should_search_by :user_id

    should_have_many :photos, :groups, :sets, :contacts, :tags, :collections
    
    should_autoload_when_accessing :name, :photos_url, :profile_url, :photos_count, :location, :with => :load_info
    should_autoload_when_accessing :icon_server, :icon_farm, :pro, :admin, :icon_url, :with => :load_info

    context "The User class" do

      should_find_one :user, :by => :username, :call => 'people.findByUsername', :path => 'rsp/user'
      should_find_one :user, :by => :email, :with => :find_email, :call => 'people.findByEmail', :path => 'rsp/user'
      should_find_one :user, :by => :id, :with => :user_id, :call => 'people.getInfo', :path => 'rsp/person'
      should_find_one :user, :by => :url, :call => 'urls.lookupUser', :path => 'rsp/user'

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

        setup { @user = User.new }

        should "be able to retrieve additional information about the current user" do
          response = mock_request_cycle :for => 'people.getInfo', :with => {:user_id => @user.id}
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