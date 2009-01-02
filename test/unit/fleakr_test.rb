require File.dirname(__FILE__) + '/../test_helper'

class FleakrTest < Test::Unit::TestCase
  
  describe "The Fleakr module" do
    
    [:api_key, :shared_secret, :mini_token, :auth_token].each do |attribute|
      it "should be able to set a value for :#{attribute}" do
        value = 'value'
        
        Fleakr.send("#{attribute}=".to_sym, value)
        Fleakr.send(attribute).should == value
      end
    end
    
    it "should provide a means to find a user by his username" do
      user = stub()
      Fleakr::Objects::User.expects(:find_by_username).with('username').returns(user)
      Fleakr.user('username').should == user
    end
    
    it "should fall back to finding a user by email if finding by username fails" do
      user = stub()
      email = 'user@host.com'
      
      Fleakr::Objects::User.stubs(:find_by_username).with(email).raises(Fleakr::ApiError)
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
   
    it "should be able to upload a collection of images" do
      glob      = '*.jpg'
      filenames = %w(one.jpg two.jpg)
      
      Dir.expects(:[]).with(glob).returns(filenames)
      
      Fleakr::Objects::Photo.expects(:upload).with('one.jpg')
      Fleakr::Objects::Photo.expects(:upload).with('two.jpg')
      
      Fleakr.upload(glob)
    end
    
    context "when generating an AuthenticationToken from an auth_token string" do

      before do
        @token = stub()
        
        Fleakr.expects(:auth_token).with().at_least_once.returns('abc123')
        Fleakr::Objects::AuthenticationToken.expects(:from_auth_token).with('abc123').returns(@token)
      end

      # Make sure to clear the cache
      after { Fleakr.instance_variable_set(:@token, nil) }
      
      it "should return the token" do
        Fleakr.token.should == @token
      end
      
      it "should cache the result" do
        2.times { Fleakr.token }
      end

    end
    
    context "when generating an AuthenticationToken from a mini_token string" do
      
      before do
        @token = stub()

        Fleakr.expects(:auth_token).with().at_least_once.returns(nil)
        Fleakr.expects(:mini_token).with().at_least_once.returns('123-123-123')
        Fleakr::Objects::AuthenticationToken.expects(:from_mini_token).with('123-123-123').returns(@token)          
      end
      
      # Make sure to clear the cache
      after { Fleakr.instance_variable_set(:@token, nil) }
      
      it "should return the token" do
        Fleakr.token.should == @token
      end
      
      it "should cache the result" do
        2.times { Fleakr.token }
      end
      
    end
    
  end
  
end