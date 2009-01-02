require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class MethodRequestTest < Test::Unit::TestCase

    describe "An instance of MethodRequest" do

      context "with API credentials" do

        before do
          @api_key = 'f00b4r'
          Fleakr.stubs(:api_key).with().returns(@api_key)
          Fleakr.stubs(:shared_secret).with().returns('sekrit')
        end

        it "should know the full query parameters" do
          request = MethodRequest.new('flickr.people.findByUsername', :username => 'foobar')

          request.parameters[:api_key].value.should  == @api_key
          request.parameters[:method].value.should   == 'flickr.people.findByUsername'
          request.parameters[:username].value.should == 'foobar'
        end
        
        it "should translate a shorthand API call" do
          request = MethodRequest.new('people.findByUsername')
          request.parameters[:method].value.should == 'flickr.people.findByUsername'
        end
        
        it "should know that it needs to sign the request" do
          ParameterList.expects(:new).with(:sign? => true).returns(stub(:<< => nil))
          request = MethodRequest.new('people.findByUsername', :sign? => true)
        end
        
        it "should know that it needs to authenticate the request" do
          ParameterList.expects(:new).with(:authenticate? => true).returns(stub(:<< => nil))
          request = MethodRequest.new('activity.userPhotos', :authenticate? => true)
        end

        it "should know the endpoint with full parameters" do
          query_parameters = 'foo=bar'
        
          request = MethodRequest.new('people.getInfo')
          request.parameters.stubs(:to_query).returns(query_parameters)
        
          uri_mock = mock() {|m| m.expects(:query=).with(query_parameters)}
          URI.expects(:parse).with("http://api.flickr.com/services/rest/").returns(uri_mock)
        
          request.__send__(:endpoint_uri).should == uri_mock
        end
        
        it "should be able to make a request" do
          endpoint_uri = stub()
          
          request = MethodRequest.new('people.findByUsername')
          request.stubs(:endpoint_uri).with().returns(endpoint_uri)
        
          Net::HTTP.expects(:get).with(endpoint_uri).returns('<xml>')
        
          request.send
        end
        
        it "should create a response from the request" do
          response_xml  = '<xml>'
          response_stub = stub()
        
          Net::HTTP.stubs(:get).returns(response_xml)
          Response.expects(:new).with(response_xml).returns(response_stub)
          
          request = MethodRequest.new('people.findByUsername')
          request.stubs(:endpoint_uri)
        
          request.send.should == response_stub
        end
        
        it "should be able to make a full request and response cycle" do
          method = 'flickr.people.findByUsername'
          params = {:username => 'foobar'}

          response = stub(:error? => false)
          
          MethodRequest.expects(:new).with(method, params).returns(stub(:send => response))
          
          MethodRequest.with_response!(method, params).should == response
        end
        
        it "should raise an exception when the full request / response cycle has errors" do
          method = 'flickr.people.findByUsername'
          params = {:username => 'foobar'}
          
          response = stub(:error? => true, :error => stub(:code => '1', :message => 'User not found'))
          
          MethodRequest.expects(:new).with(method, params).returns(stub(:send => response))
          
          lambda do
            MethodRequest.with_response!('flickr.people.findByUsername', :username => 'foobar')
          end.should raise_error(Fleakr::ApiError)
        end
        
      end
    end
    
  end
end