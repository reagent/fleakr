require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class UserTest < Test::Unit::TestCase

    describe "The User class" do
      
      it "should be able to find a user by his username" do
        response = stub(:body => read_fixture('people.findByUsername'))
        Request.expects(:new).with('people.findByUsername', :username => 'frootpantz').returns(stub(:send => response))
        
        user = User.find_by_username('frootpantz')
        
        user.id.should       == '31066442@N69'
        user.username.should == 'frootpantz'
      end
      
    end
    
  end
end