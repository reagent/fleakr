require File.dirname(__FILE__) + '/../../../test_helper'

class RequestImplementation
  include Fleakr::Api::Request
end

module Fleakr::Api
  class RequestImplementationTest < Test::Unit::TestCase

    describe "The RequestImplementation class" do

      before { @token = stub() }
      
      # Make sure to clear the cache
      after { Request.instance_variable_set(:@token, nil) }
      
      context "when generating an AuthenticationToken from an auth_token string" do

        before do
          Fleakr.expects(:auth_token).with().at_least_once.returns('abc123')
          Fleakr::Objects::AuthenticationToken.expects(:from_auth_token).with('abc123').returns(@token)
        end
        
        it "should return the token" do
          Request.token.should == @token
        end
        
        it "should cache the result" do
          2.times { Request.token }
        end

      end
      
      context "when generating an AuthenticationToken from a mini_token string" do
        
        before do
          Fleakr.expects(:auth_token).with().at_least_once.returns(nil)
          Fleakr.expects(:mini_token).with().at_least_once.returns('123-123-123')
          Fleakr::Objects::AuthenticationToken.expects(:from_mini_token).with('123-123-123').returns(@token)          
        end
        
        it "should return the token" do
          Request.token.should == @token
        end
        
        it "should cache the result" do
          2.times { Request.token }
        end
        
      end
      
    end

  end
end
