require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class MethodRequestTest < Test::Unit::TestCase

    describe "An instance of MethodRequest" do

      context "with an API key" do

        before do
          @api_key = 'f00b4r'
          Fleakr.stubs(:api_key).with().returns(@api_key)
        end

        it "should know the full query parameters" do
          request = MethodRequest.new('flickr.people.findByUsername', :username => 'foobar')

          expected = {
            :api_key  => @api_key,
            :method   => 'flickr.people.findByUsername',
            :username => 'foobar'
          }

          request.__send__(:query_parameters).should == expected
        end
        
        it "should translate a shorthand API call" do
          request = MethodRequest.new('people.findByUsername')
          request.__send__(:query_parameters)[:method].should == 'flickr.people.findByUsername'
        end
        
        it "should know that it needs to sign the request" do
          request = MethodRequest.new('people.findByUsername', :sign? => true)
          request.sign?.should be(true)
        end
        
        it "should know that it needs to authenticate the request" do
          request = MethodRequest.new('activity.userPhotos', :authenticate? => true)
          request.authenticate?.should be(true)
        end
        
        it "should return the default parameters when the call doesn't need to be signed" do
          request = MethodRequest.new('people.findByUsername')
          request.parameters.should == {
            :api_key => @api_key,
            :method  => 'flickr.people.findByUsername'
          }
        end

        it "should know the endpoint with full parameters" do
          query_parameters = 'foo=bar'
        
          request = MethodRequest.new('people.getInfo')
          request.stubs(:query_parameters).with().returns(query_parameters)
        
          uri_mock = mock() {|m| m.expects(:query=).with(query_parameters)}
        
          URI.expects(:parse).with("http://api.flickr.com/services/rest/").returns(uri_mock)
        
          request.__send__(:endpoint_uri).should == uri_mock
        end
        
        it "should be able to make a full request and response cycle" do
          response = stub(:error? => false)
          Response.expects(:new).with(kind_of(String)).returns(response)
        
          MethodRequest.with_response!('flickr.people.findByUsername', :username => 'foobar').should == response
        end
        
        it "should raise an exception when the full request / response cycle has errors" do
          response = stub(:error? => true, :error => stub(:code => '1', :message => 'User not found'))
          Response.stubs(:new).with(kind_of(String)).returns(response)
        
          lambda do
            MethodRequest.with_response!('flickr.people.findByUsername', :username => 'foobar')
          end.should raise_error(Fleakr::Api::Request::ApiError)
        end
        
      end
    end
    
  end
end