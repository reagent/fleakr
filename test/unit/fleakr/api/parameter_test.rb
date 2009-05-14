require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ParameterTest < Test::Unit::TestCase
    
    context "An instance of the Parameter class" do
      
      should "have a name" do
        parameter = Parameter.new('foo')
        parameter.name.should == 'foo'
      end
      
      should "know to include it in the signature by default" do
        parameter = Parameter.new('foo')
        parameter.include_in_signature?.should be(true)
      end
      
      should "know not to include it in the signature" do
        parameter = Parameter.new('foo', false)
        parameter.include_in_signature?.should be(false)
      end
      
      should "be able to compare itself to another parameter instance" do
        p1 = Parameter.new('z', 'a')
        p2 = Parameter.new('a', 'z')
        
        (p1 <=> p2).should == 1
      end
      
      
    end
    
  end
end