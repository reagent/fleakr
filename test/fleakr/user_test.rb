require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class UserTest < Test::Unit::TestCase

    describe "The User class" do
    
      it "should be able to find a user by his username" do
        user = stub()
        response = mock_request_cycle :for => 'people.findByUsername', :with => {:username => 'frootpantz'}
        
        User.expects(:new).with(response.body).returns(user)
        User.find_by_username('frootpantz').should == user
      end
    
      it "should be able to find a user by his email" do
        user = stub()
        response = mock_request_cycle :for => 'people.findByEmail', :with => {:find_email => 'frootpantz@example.com'}
        
        User.expects(:new).with(response.body).returns(user)
        User.find_by_email('frootpantz@example.com').should == user
      end
      
    end

    describe "An instance of User" do

      before do
        @user = User.new(Hpricot.XML(read_fixture('people.findByUsername')))
        @user.populate_from(Hpricot.XML(read_fixture('people.getInfo')))
      end

      it "should have a value for :id" do
        @user.id.should == '31066442@N69'
      end
      
      it "should have a value for :username" do
        @user.username.should == 'frootpantz'
      end
      
      it "should have a value for :photos_url" do
        @user.photos_url.should == 'http://www.flickr.com/photos/frootpantz/'
      end
      
      it "should have a value for :profile_url" do
        @user.profile_url.should == 'http://www.flickr.com/people/frootpantz/'
      end
      
      it "should have a value for :photos_count" do
        @user.photos_count.should == '3907'
      end
      
      it "should have a value for :icon_server" do
        @user.icon_server.should == '30'
      end
      
      it "should have a value for :icon_farm" do
        @user.icon_farm.should == '1'
      end
      
      it "should be able to retrieve the user's associated sets" do
        sets = [stub()]
        @user.stubs(:id).with().returns('1')

        Set.expects(:find_all_by_user_id).with('1').returns(sets)
        
        @user.sets.should == sets
      end
      
      it "should memoize the results returned for this user's sets" do
        Set.expects(:find_all_by_user_id).once.returns([])
        2.times { @user.sets }
      end
      
      it "should be able to retrieve the user's associated groups" do
        groups = [stub()]
        @user.stubs(:id).with().returns('1')
        
        Group.expects(:find_all_by_user_id).with('1').returns(groups)
        
        @user.groups.should == groups
      end
      
      it "should memoize the results returned for this user's group" do
        Group.expects(:find_all_by_user_id).once.returns([])
        2.times { @user.groups }
      end
      
      it "should be able to retrieve the user's photos" do
        photos = [stub()]
        @user.stubs(:id).with().returns('1')
        
        Photo.expects(:find_all_by_user_id).with('1').returns(photos)
        @user.photos.should == photos
      end
      
      it "should memoize the results returned for this user's photos" do
        Photo.expects(:find_all_by_user_id).once.returns([])
        2.times { @user.photos }
      end
      
      it "should be able to retrieve additional information about the current user" do
        response = mock_request_cycle :for => 'people.getInfo', :with => {:user_id => @user.id}
        @user.expects(:populate_from).with(response.body)
        
        @user.load_info
      end
      
      it "should be able to generate an icon URL when the :icon_server value is greater than zero" do
        @user.stubs(:icon_server).with().returns('1')
        @user.stubs(:icon_farm).with().returns('2')
        @user.stubs(:id).with().returns('45')
        
        @user.icon_url.should == 'http://farm2.static.flickr.com/1/buddyicons/45.jpg'
      end
      
      it "should return the default icon URL when the :icon_server value is zero" do
        @user.stubs(:icon_server).with().returns('0')
        @user.icon_url.should == 'http://www.flickr.com/images/buddyicon.jpg'
      end
      
      it "should return the default icon URL when the :icon_server value is nil" do
        @user.stubs(:icon_server).with().returns(nil)
        @user.icon_url.should == 'http://www.flickr.com/images/buddyicon.jpg'
      end
      
    end

  end
end