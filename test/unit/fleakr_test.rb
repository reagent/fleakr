require File.dirname(__FILE__) + '/../test_helper'

class FleakrTest < Test::Unit::TestCase
  
  describe "The Fleakr module" do
    
    it "should be able to set an API key" do
      key = 'f00b4r'
      Fleakr.api_key = key
      
      Fleakr.api_key.should == key
    end
    
    it "should be able to set the shared secret" do
      secret = 'ssssshhhh'
      
      Fleakr.shared_secret = secret
      Fleakr.shared_secret.should == secret
    end
    
    it "should provide a means to find a user by his username" do
      user = stub()
      Fleakr::Objects::User.expects(:find_by_username).with('username').returns(user)
      Fleakr.user('username').should == user
    end
    
    it "should fall back to finding a user by email if finding by username fails" do
      user = stub()
      email = 'user@host.com'
      
      Fleakr::Objects::User.stubs(:find_by_username).with(email).raises(Fleakr::Api::Request::ApiError)
      Fleakr::Objects::User.expects(:find_by_email).with(email).returns(user)
      
      Fleakr.user(email).should == user
    end
    
    it "should be able to perform text searches" do
      photos = [stub()]
      
      Fleakr::Objects::Search.expects(:new).with(:text => 'foo').returns(stub(:results => photos))
      Fleakr.search('foo').should == photos
    end
    
    it "should be able to perform searches based on tags" do
      Fleakr::Objects::Search.expects(:new).with(:tags => %w(one two)).returns(stub(:results => []))
      Fleakr.search(:tags => %w(one two))
    end
    
  end
  
end