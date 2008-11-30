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
        response_body = Hpricot.XML(read_fixture('people.findByUsername'))
        @user = User.new(response_body)
      end

      it "should have a value for :id" do
        @user.id.should == '31066442@N69'
      end
      
      it "should have a value for :username" do
        @user.username.should == 'frootpantz'
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
      
    end

  end
end