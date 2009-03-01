require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class AuthenticationTokenTest < Test::Unit::TestCase
    
    describe "The AuthenticationToken class" do
      
      it "should be able to create an instance from a mini_token" do
        token = '123-123-123'
        auth_token = stub()
        
        response = mock_request_cycle :for => 'auth.getFullToken', :with => {:mini_token => token, :authenticate? => false}
        
        AuthenticationToken.expects(:new).with(response.body).returns(auth_token)
        
        AuthenticationToken.from_mini_token(token).should == auth_token
      end
      
      it "should be able to create an instance from an auth_token" do
        token      = 'abc123'
        auth_token = stub()

        response = mock_request_cycle :for => 'auth.checkToken', :with => {:auth_token => token, :authenticate? => false}
        
        AuthenticationToken.expects(:new).with(response.body).returns(auth_token)
        AuthenticationToken.from_auth_token(token).should == auth_token
      end
      
      
      it "should be able to create an instance from a frob" do
        frob       = '12345678901234567-abcde89012fg3456-7890123'
        auth_token = stub()
        
        response = mock_request_cycle :for => 'auth.getToken', :with => {:frob => frob, :authenticate? => false}
        
        AuthenticationToken.expects(:new).with(response.body).returns(auth_token)
        AuthenticationToken.from_frob(frob).should == auth_token
      end
      
    end
    
    describe "An instance of the AuthenticationToken class" do
      
      context "when populating from an XML document" do
        
        before do
          @object = AuthenticationToken.new(Hpricot.XML(read_fixture('auth.getFullToken')))
        end
        
        should_have_a_value_for :value       => 'abc-123'
        should_have_a_value_for :permissions => 'delete'
        should_have_a_value_for :user_id     => '31066442@N69'
        should_have_a_value_for :full_name   => 'Sir Froot Pants'
        should_have_a_value_for :user_name   => 'frootpantz'
        
      end
      
    end
    
  end
end