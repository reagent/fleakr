require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class MethodRequestTest < Test::Unit::TestCase

    context "An instance of the MethodRequest class" do

      should "know the endpoint URL" do
        request = MethodRequest.new('people.findByUsername')
        request.endpoint_url.should == 'http://api.flickr.com/services/rest/'
      end

      should "add the method name to the list of parameters" do
        parameter_list = mock() {|p| p.expects(:add_option).with(:method, 'flickr.people.findByUsername') }
        MethodRequest.any_instance.stubs(:parameters).with().returns(parameter_list)

        MethodRequest.new('flickr.people.findByUsername')
      end

      should "translate a shorthand API call" do
        request = MethodRequest.new('people.findByUsername')
        request.method.should == 'flickr.people.findByUsername'
      end

      should "be able to make a request" do
        endpoint_uri = stub()

        request = MethodRequest.new('people.findByUsername')
        request.stubs(:endpoint_uri).with().returns(endpoint_uri)

        Net::HTTP.expects(:get).with(endpoint_uri).returns('<xml>')

        request.send
      end

      should "create a response from the request" do
        response_xml  = '<xml>'
        response_stub = stub()

        Net::HTTP.stubs(:get).returns(response_xml)
        Response.expects(:new).with(response_xml).returns(response_stub)

        request = MethodRequest.new('people.findByUsername')
        request.stubs(:endpoint_uri)

        request.send.should == response_stub
      end

      should "be able to make a full request and response cycle" do
        method = 'flickr.people.findByUsername'
        params = {:username => 'foobar'}

        response = stub(:error? => false)

        MethodRequest.expects(:new).with(method, params).returns(stub(:send => response))

        MethodRequest.with_response!(method, params).should == response
      end

      should "raise an exception when the full request / response cycle has errors" do
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