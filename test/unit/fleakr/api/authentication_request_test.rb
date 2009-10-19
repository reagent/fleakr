require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class AuthenticationRequestTest < Test::Unit::TestCase
    
    context "An instance of AuthenticationRequest" do
      
      should "know the endpoint URL" do
        request = AuthenticationRequest.new
        request.endpoint_url.should == 'http://flickr.com/services/auth/'
      end
      
      should "be able to make a request" do
        endpoint_uri = stub()
        
        request = AuthenticationRequest.new
        request.stubs(:endpoint_uri).with().returns(endpoint_uri)
      
        Net::HTTP.expects(:get_response).with(endpoint_uri).returns('response')
      
        request.response.should == 'response'
      end
      
      should "know the authorization_url for the authentication request" do
        response_headers = {'Location' => 'http://example.com/auth'}
        response = stub() {|r| r.stubs(:header).with().returns(response_headers) }
        
        request = AuthenticationRequest.new
        request.stubs(:response).with().returns(response)
        
        request.authorization_url.should == 'http://example.com/auth'
      end
      
    end
    
  end
end