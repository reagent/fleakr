require File.dirname(__FILE__) + '/../../../../test_helper'

module URI
  class HTTPTest < Test::Unit::TestCase

    describe "An instance of URI::HTTP" do

      before do
        @uri = URI::HTTP.new('http', nil, 'www.example.com', 80, nil, '/', nil, nil, nil)
      end

      it "should allow setting of the query string as a hash" do
        @uri.query = {:one => 'two'}
        @uri.query.should == 'one=two'
      end
      
      it "should create multiple query parameters from a hash" do
        @uri.query = {:one => 'two', :three => 'four'}
        @uri.query.split('&').sort.should == %w(one=two three=four)
      end
      
      it "should escape the query parameters" do
        @uri.query = {:name => 'Mr. Crystal?'}
        @uri.query.should == "name=Mr.+Crystal%3F"
      end
      
      it "should allow setting the query string as a String" do
        @uri.query = 'one=two'
        @uri.query.should == 'one=two'
      end

    end

  end
end