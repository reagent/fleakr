require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ErrorTest < Test::Unit::TestCase
    
    context "An instance of the Error class" do
      
      should "have a code and a message" do
        response_xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<rsp stat=\"fail\">\n\t<err code=\"1\" msg=\"User not found\" />\n</rsp>\n"
        
        error = Error.new(Hpricot.XML(response_xml))
        
        error.code.should == '1'
        error.message.should == 'User not found'
      end
      
    end
    
    
  end
end