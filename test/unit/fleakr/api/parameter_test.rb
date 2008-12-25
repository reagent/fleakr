require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ParameterTest < Test::Unit::TestCase
    
    describe "An instance of the Parameter class" do
      
      it "should have a name" do
        parameter = Parameter.new('foo', nil)
        parameter.name.should == 'foo'
      end
      
      it "should have a value" do
        parameter = Parameter.new('foo', 'bar')
        parameter.value.should == 'bar'
      end
      
      it "should know to include it in the signature by default" do
        parameter = Parameter.new('foo', 'bar')
        parameter.include_in_signature?.should be(true)
      end
      
      it "should know not to include it in the signature" do
        parameter = Parameter.new('foo', 'bar', false)
        parameter.include_in_signature?.should be(false)
      end
      
      it "should know how to generate the query representation of itself" do
        parameter = Parameter.new('foo', 'bar')
        parameter.to_query.should == 'foo=bar'
      end
      
      it "should escape the value when generating the query representation" do
        parameter = Parameter.new('foo', 'Mr. Crystal?')
        parameter.to_query.should == 'foo=Mr.+Crystal%3F'
      end
      
      it "should know how to generate the form representation of itself" do
        parameter = Parameter.new('foo', 'bar')
        expected = 
          'Content-Disposition: form-data; name="foo"' + "\r\n" +
          "\r\n" +
          "bar\r\n"
          
        parameter.to_form.should == expected
      end
      
      it "should be able to compare itself to another parameter instance" do
        p1 = Parameter.new('z', 'a')
        p2 = Parameter.new('a', 'z')
        
        (p1 <=> p2).should == 1
      end
      
      
    end
    
  end
end