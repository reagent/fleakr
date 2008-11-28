require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class ResponseTest < Test::Unit::TestCase

    describe "An instance of Response" do

      it "should retrieve the values from the raw response data" do
        response = Response.new('user' => {'nsid' => '69'})
        response.values_for(:user).should == {'nsid' => '69'}
      end

      it "should know if there are errors on the response" do
        response = Response.new({'err' => {'msg' => 'You are a moron'}, 'person' => 'foo'})
        response.error?.should be(true)
      end

    end

  end
end