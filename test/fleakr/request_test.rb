require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class RequestTest < Test::Unit::TestCase

    describe "A Request instance" do

      it "should be able to set an API key" do
        key = 'f00b4r'
        Request.api_key = key
        key.should == Request.api_key
      end

      context "with an API key" do

        before do
          @api_key = 'f00b4r'
          Request.stubs(:api_key).with().returns(@api_key)
        end

        it "should be able to make a request" do
          r = Request.new('method', :param => 'foo')
          Request.expects(:get).with('/services/rest/', :query => {:method => 'flickr.method', :api_key => @api_key, :param => 'foo'}).returns({'rsp' => {}})

          r.send
        end

        it "should ignore the case when the user supplies the flickr namespace to the method call" do
          r = Request.new('flickr.method')
          Request.expects(:get).with(kind_of(String), :query => {:method => 'flickr.method', :api_key => @api_key}).returns({'rsp' => {}})
          
          r.send
        end

        it "should create a response object from the response data" do
          response = stub()
          
          r = Request.new('method')
          Request.stubs(:get).with(kind_of(String), kind_of(Hash)).returns({'rsp' => {'user' => {'id' => '1'}}})
          
          Response.expects(:new).with({'user' => {'id' => '1'}}).returns(response)
          
          r.send
          r.response.should == response
        end

      end

    end
  end
end