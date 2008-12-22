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
    
    describe "A RequestImplementation instance" do

      before { @request = RequestImplementation.new }

      context "with an API key" do

        before do
          @api_key = 'f00b4r'
          Fleakr.stubs(:api_key).with().returns(@api_key)
        end

        it "should escape the keys and values in the parameter list" do
          @request.stubs(:parameters).with().returns(:username => 'the decapitator')
          @request.__send__(:query_parameters).split('&').include?("username=#{CGI.escape('the decapitator')}").should be(true)
        end
        
        it "should return an empty hash for parameters by default" do
          @request.parameters.should == {}
        end
        
        it "should include the signature in the query parameters when the call is to be signed" do
          @request.stubs(:sign?).with().returns(true)
          @request.stubs(:signature).with().returns('sig')
          
          params = @request.__send__(:query_parameters).split('&')

          params.include?('api_sig=sig').should be(true)
        end


        it "should know that it doesn't need to sign the request" do
          @request.sign?.should be(false)
        end

        it "should know that it doesn't need to authenticate by default" do
          @request.authenticate?.should be(false)
        end

        it "should know that it needs to sign the request if it is using authentication" do
          @request.stubs(:authenticate?).with().returns(true)
          @request.sign?.should be(true)
        end
        
        it "should be able to calculate the correct signature" do
          Fleakr.stubs(:shared_secret).with().returns('secret')
          
          @request.stubs(:sign?).with().returns(true)
          @request.stubs(:parameters).with().returns(:api_key => @api_key, :method => 'flickr.people.findByUsername')
          sig = Digest::MD5.hexdigest("secretapi_key#{@api_key}methodflickr.people.findByUsername")
          
          @request.__send__(:signature).should == sig
        end

        it "should return the :auth_token when the call needs to be authenticated" do
          Request.expects(:token).with().returns(stub(:value => 'toke'))
          
          @request.stubs(:authenticate?).with().returns(true)
          @request.parameters.should == {:auth_token => 'toke'}
        end
        
        it "should be able to make a request" do
          endpoint_uri = stub()
          @request.stubs(:endpoint_uri).with().returns(endpoint_uri)
          
          Net::HTTP.expects(:get).with(endpoint_uri).returns('<xml>')
        
          @request.send
        end
        
        it "should create a response from the request" do
          response_xml  = '<xml>'
          response_stub = stub()
        
          Net::HTTP.stubs(:get).returns(response_xml)
          Response.expects(:new).with(response_xml).returns(response_stub)
          @request.stubs(:endpoint_uri)
          
          @request.send.should == response_stub
        end

      end

    end
  end
end
