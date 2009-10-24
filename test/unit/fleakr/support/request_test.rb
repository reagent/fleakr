require File.dirname(__FILE__) + '/../../../test_helper'

class BasicRequest
  include Fleakr::Support::Request
  
  def endpoint_url
    'http://example.com'
  end
  
end

module Fleakr
  class RequestTest < Test::Unit::TestCase
    
    context "An instance of the BasicRequest class with the Request mix-in" do
      
      should "have a collection of parameters" do
        params = {:perms => 'read'}
        Fleakr::Api::ParameterList.expects(:new).with(params, true).returns('params')
        
        request = BasicRequest.new(params)
        request.parameters.should == 'params'
      end
      
      should "know not to authenticate the request if asked not to" do
        Fleakr::Api::ParameterList.expects(:new).with({:perms => 'read'}, false).returns('params')
        
        request = BasicRequest.new(:perms => 'read', :authenticate? => false)
        request.parameters.should == 'params'
      end
      
      should "know the endpoint with full URL parameters" do
        request = BasicRequest.new
        request.parameters.stubs(:to_query).with().returns('query')
        
        request.endpoint_uri.to_s.should == 'http://example.com?query'
      end
      
    end
    
  end
end
