require File.dirname(__FILE__) + '/../test_helper'

class FleakrTest < Test::Unit::TestCase
  
  context "The Fleakr module" do
    
    [:api_key, :shared_secret, :auth_token].each do |attribute|
      should "be able to set a value for :#{attribute}" do
        value = 'value'
        
        Fleakr.send("#{attribute}=".to_sym, value)
        Fleakr.send(attribute).should == value
      end
    end
    
    should "provide a means to find a user by his username" do
      user = stub()
      Fleakr::Objects::User.expects(:find_by_username).with('username', {}).returns(user)
      Fleakr.user('username').should == user
    end
    
    should "fall back to finding a user by email if finding by username fails" do
      user = stub()
      email = 'user@host.com'
      
      Fleakr::Objects::User.stubs(:find_by_username).with(email, {}).raises(Fleakr::ApiError)
      Fleakr::Objects::User.expects(:find_by_email).with(email, {}).returns(user)
      
      Fleakr.user(email).should == user
    end
    
    should "fall back to finding a user by URL if username and email both fail" do
      user = stub()
      url = 'http://flickr.com/photos/user'
      
      Fleakr::Objects::User.stubs(:find_by_username).with(url, {}).raises(Fleakr::ApiError)
      Fleakr::Objects::User.stubs(:find_by_email).with(url, {}).raises(Fleakr::ApiError)
      Fleakr::Objects::User.expects(:find_by_url).with(url, {}).returns(user)
            
      Fleakr.user(url).should == user
    end

    should "not return nil if a user cannot be found" do
      data = 'data'
      
      Fleakr::Objects::User.stubs(:find_by_username).with(data, {}).raises(Fleakr::ApiError)
      Fleakr::Objects::User.stubs(:find_by_email).with(data, {}).raises(Fleakr::ApiError)
      Fleakr::Objects::User.stubs(:find_by_url).with(data, {}).raises(Fleakr::ApiError)
            
      Fleakr.user(data).should be_nil
    end
    
    should "provide additional options to the finder call if supplied" do
      user = stub()
      Fleakr::Objects::User.expects(:find_by_username).with('username', :auth_token => 'toke').returns(user)
      Fleakr.user('username', :auth_token => 'toke').should == user
    end
    
    should "find all contacts for the authenticated user" do
      Fleakr::Objects::Contact.expects(:find_all).with({}).returns('contacts')
      Fleakr.contacts.should == 'contacts'
    end
    
    should "allow filtering when finding contacts for the authenticated user" do
      Fleakr::Objects::Contact.expects(:find_all).with(:filter => :friends).returns('contacts')
      Fleakr.contacts(:friends).should == 'contacts'
    end
    
    should "allow passing of additional parameters when finding contacts for the authenticated user" do
      Fleakr::Objects::Contact.expects(:find_all).with(:filter => :friends, :page => 1).returns('contacts')
      Fleakr.contacts(:friends, :page => 1).should == 'contacts'
    end
    
    should "be able to perform text searches" do
      photos = [stub()]
      
      Fleakr::Objects::Search.expects(:new).with(:text => 'foo').returns(stub(:results => photos))
      Fleakr.search('foo').should == photos
    end
    
    should "be able to perform searches based on tags" do
      Fleakr::Objects::Search.expects(:new).with(:tags => %w(one two)).returns(stub(:results => []))
      Fleakr.search(:tags => %w(one two))
    end
   
    # TODO: refactor uploading tests?
    should "be able to upload a collection of images" do
      glob      = '*.jpg'
      filenames = %w(one.jpg two.jpg)
      
      Dir.expects(:[]).with(glob).returns(filenames)
      
      Fleakr::Objects::Photo.expects(:upload).with('one.jpg', {})
      Fleakr::Objects::Photo.expects(:upload).with('two.jpg', {})
      
      Fleakr.upload(glob)
    end
    
    should "return recently uploaded photos" do
      filename  = '/path/to/image.jpg'
      new_image = stub()
      
      Dir.expects(:[]).with(filename).returns([filename])
      Fleakr::Objects::Photo.expects(:upload).with(filename, {}).returns(new_image)
      
      Fleakr.upload(filename).should == [new_image]
    end
    
    should "be able to pass options for the uploaded files" do
      filename  = '/path/to/image.jpg'
      new_image = stub()
      
      Dir.expects(:[]).with(filename).returns([filename])
      Fleakr::Objects::Photo.expects(:upload).with(filename, :title => 'bop bip').returns(new_image)
      
      Fleakr.upload(filename, :title => 'bop bip').should == [new_image]
    end
    
    should "be able to generate the authorization_url with default permissions" do
      request = stub() {|r| r.stubs(:authorization_url).with().returns('auth_url') }
      Fleakr::Api::AuthenticationRequest.expects(:new).with(:perms => :read).returns(request)
      
      Fleakr.authorization_url.should == 'auth_url'
    end
    
    should "be able to specify different permissions when generating the authorization_url" do
      request = stub() {|r| r.stubs(:authorization_url).with().returns('auth_url') }
      Fleakr::Api::AuthenticationRequest.expects(:new).with(:perms => :delete).returns(request)
      
      Fleakr.authorization_url(:delete).should == 'auth_url'
    end
   
    should "be able to retrieve a token from the provided frob" do
      Fleakr::Objects::AuthenticationToken.expects(:from_frob).with('frob').returns('toke')
      Fleakr.token_from_frob('frob').should == 'toke'
    end
    
    should "be able to retrieve a token from the provided mini-token" do
      Fleakr::Objects::AuthenticationToken.expects(:from_mini_token).with('mini_token').returns('toke')
      Fleakr.token_from_mini_token('mini_token').should == 'toke'
    end
    
    should "be able to get the user for the provided auth token" do
      token = stub() {|t| t.stubs(:user).with().returns('user') }
      
      Fleakr::Objects::AuthenticationToken.expects(:from_auth_token).with('toke').returns(token)
      
      Fleakr.user_for_token('toke').should == 'user'
    end
    
  end
  
end