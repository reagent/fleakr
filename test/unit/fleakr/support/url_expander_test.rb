require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr
  module Support

    class UrlExpanderTest < Test::Unit::TestCase

      context "The UrlExpander class" do

        should "be able to expand a URL" do
          expander = stub() {|e| e.stubs(:expanded_path).with().returns('/expanded/path') }
          UrlExpander.stubs(:new).with('url').returns(expander)

          UrlExpander.expand('url').should == '/expanded/path'
        end

      end

      context "An instance of the UrlExpander class" do

        should "know the path that needs to be expanded" do
          expander = UrlExpander.new('http://flic.kr/p/7a9yQV')
          expander.path_to_expand.should == '/photo.gne?short=7a9yQV'
        end

        should "know the expanded path" do
          response = stub()
          client   = stub()

          response.stubs(:[]).with('location').returns('/expanded/path')
          client.stubs(:head).with('/photo.gne?short=7a9yQV').returns(response)

          Net::HTTP.stubs(:start).with('www.flickr.com', 80).yields(client)

          expander = UrlExpander.new('http://flic.kr/p/7a9yQV')
          expander.expanded_path.should == '/expanded/path'
        end

      end

    end

  end
end