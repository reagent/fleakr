require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Support
  class AttributeTest < Test::Unit::TestCase
    describe "An instance of the Attribute class" do

      it "should know the name of the attribute" do
        attr = Attribute.new('foo')
        attr.name.should == :foo
      end

      it "should infer the xpath information from the attribute name" do
        attr = Attribute.new('foo')
        attr.xpath.should == 'foo'
      end
      
      it "should use a string value for the xpath from the inferred attribute name" do
        attr = Attribute.new(:foo)
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
      
      it "should not infer the xpath value when the attribute is set" do
        attr = Attribute.new(:foo, :attribute => 'bogon')
        attr.xpath.should be(nil)
      end
      
      it "should be able to pull simple values from an XML document" do
        document = Hpricot.XML('<name>Bassdrive</name>')
        attr = Attribute.new('name')
        attr.value_from(document).should == 'Bassdrive'
      end
      
      it "should be able to pull an attribute value from the current XML node" do
        document = Hpricot.XML('<user id="1337" />').at('user')
        attr = Attribute.new(:id, :attribute => 'id')
        attr.value_from(document).should == '1337'
      end
      
      it "should be able to pull an attribute value for a node and attribute" do
        document = Hpricot.XML('<station><genre slug="dnb">Drum & Bass</genre></station>')
        attr = Attribute.new(:slug, :xpath => 'station/genre', :attribute => 'slug')
        attr.value_from(document).should == 'dnb'
      end
      
      it "should return nil if it cannot find the specified node" do
        document = Hpricot.XML('<user id="1" />')
        attr = Attribute.new(:photoset, :attribute => 'id')
        attr.value_from(document).should be(nil)
      end

    end
  end
end