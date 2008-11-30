require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class ErrorTest < Test::Unit::TestCase
    
    describe "An instance of the Error class" do
      
      it "should have a code and a message" do
        error = Error.new('1', 'User not found')
        
        error.code.should == '1'
        error.message.should == 'User not found'
      end
      
    end
    
    
  end
end