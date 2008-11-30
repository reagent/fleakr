require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class UserTest < Test::Unit::TestCase

    describe "The User class" do
      
      it "should be able to find a user by his username" do
        mock_request_cycle :for => 'people.findByUsername', :with => {:username => 'frootpantz'}
        
        user = User.find_by_username('frootpantz')
        
        user.id.should       == '31066442@N69'
        user.username.should == 'frootpantz'
      end
      
    end
    
    describe "An instance of User" do
      
      before do
        @user_id = '1'
        
        @user = User.new(Hpricot.XML(read_fixture('people.findByUsername')))
        @user.stubs(:id).with().returns(@user_id)
      end
      
      it "should retrieve the sets for this user" do
        sets = [stub()]
        Set.expects(:find_all_by_user_id).with(@user_id).returns(sets)
        
        @user.sets.should == sets
      end
      
      it "should memoize the results returned for this user's sets" do
        Set.expects(:find_all_by_user_id).once.returns([])
        
        2.times { @user.sets }
      end
      
    end
    
  end
end