require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
    class RequestTest < Test::Unit::TestCase

      describe "A Request instance" do

        context "with an API key" do

          before do
            @api_key = 'f00b4r'
            Fleakr.stubs(:api_key).with().returns(@api_key)
          end

          it "should know the full query parameters" do
            request = Request.new('flickr.people.findByUsername', :username => 'foobar')

            expected = [
              "api_key=#{@api_key}",
              "method=flickr.people.findByUsername",
              "username=foobar"
            ]

            request.__send__(:query_parameters).split('&').sort.should == expected
          end

          it "should escape the keys and values in the parameter list" do
            request = Request.new('flickr.people.findByUsername', :username => 'the decapitator')
            request.__send__(:query_parameters).split('&').include?("username=#{CGI.escape('the decapitator')}").should be(true)
          end

          it "should translate a shorthand API call" do
            request = Request.new('people.findByUsername')
            request.__send__(:query_parameters).split('&').include?('method=flickr.people.findByUsername').should be(true)
          end

          it "should know the endpoint with full parameters" do
            query_parameters = 'foo=bar'

            request = Request.new('people.getInfo')
            request.stubs(:query_parameters).with().returns(query_parameters)

            uri_mock = mock() {|m| m.expects(:query=).with(query_parameters)}

            URI.expects(:parse).with("http://api.flickr.com/services/rest/").returns(uri_mock)

            request.__send__(:endpoint_uri).should == uri_mock
          end

          it "should be able to make a request" do
            endpoint_uri = stub()

            request = Request.new('flickr.people.findByUsername')

            request.stubs(:endpoint_uri).with().returns(endpoint_uri)
            Net::HTTP.expects(:get).with(endpoint_uri).returns('<xml>')

            request.send
          end

          it "should create a response from the request" do
            response_xml  = '<xml>'
            response_stub = stub()

            request = Request.new('flickr.people.findByUsername')

            Net::HTTP.stubs(:get).returns(response_xml)
            Response.expects(:new).with(response_xml).returns(response_stub)

            request.send.should == response_stub
          end

          it "should be able to make a full request and response cycle" do
            response = stub(:error? => false)
            Response.expects(:new).with(kind_of(String)).returns(response)

            Request.with_response!('flickr.people.findByUsername', :username => 'foobar').should == response
          end

          it "should raise an exception when the full request / response cycle has errors" do
            response = stub(:error? => true, :error => stub(:code => '1', :message => 'User not found'))
            Response.stubs(:new).with(kind_of(String)).returns(response)

            lambda do
              Request.with_response!('flickr.people.findByUsername', :username => 'foobar')
            end.should raise_error(Fleakr::Api::Request::ApiError)
          end

        end

      end
    end
  end
