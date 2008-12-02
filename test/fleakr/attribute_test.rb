require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class AttributeTest < Test::Unit::TestCase
    describe "An instance of the Attribute class" do

      it "should know the name of the attribute" do
        attr = Attribute.new('foo')
        attr.name.should == 'foo'
      end

      it "should infer the xpath information from the attribute name" do
        attr = Attribute.new('foo')
        attr.xpath.should == 'foo'
      end
      
      it "should allow the setting of the xpath information" do
        attr = Attribute.new('foo', :xpath => 'bar')
        attr.xpath.should == 'bar'
      end
      
      it "should have a default attribute value of nil" do
        attr = Attribute.new('foo')
        attr.attribute.should be(nil)
      end
      
      it "should allow the setting of the attribute value" do
        attr = Attribute.new('foo', :attribute => 'bogon')
        attr.attribute.should == 'bogon'
      end

    end
  end
end