require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ResponseTest < Test::Unit::TestCase

    context "An instance of Response" do

      should "provide the response body as an Hpricot element" do
        response_xml = '<xml>'
        hpricot_stub = stub()

        Hpricot.expects(:XML).with(response_xml).returns(hpricot_stub)
        
        response = Response.new(response_xml)
        response.body.should == hpricot_stub
      end
      
      should "memoize the Hpricot document" do
        response = Response.new('<xml>')
        
        Hpricot.expects(:XML).with(kind_of(String)).once.returns(stub())
        
        2.times { response.body }
      end
      
      should "know if there are errors in the response" do
        response_xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<rsp stat=\"fail\">\n\t<err code=\"1\" msg=\"User not found\" />\n</rsp>\n"
        response = Response.new(response_xml)
        
        response.error?.should be(true)
      end
      
      should "not have an error if there are no errors in the XML" do
        response = Response.new(read_fixture('people.findByUsername'))
        response.error.should be(nil)
      end
      
      should "have an error if there is an error in the response" do
        response_xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<rsp stat=\"fail\">\n\t<err code=\"1\" msg=\"User not found\" />\n</rsp>\n"
        response = Response.new(response_xml)
        
        response.error.code.should == '1'
        response.error.message.should == 'User not found'
      end

    end

  end
end