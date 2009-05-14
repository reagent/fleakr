require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Support
  class AttributeTest < Test::Unit::TestCase
    context "An instance of the Attribute class" do

      should "know the name of the attribute" do
        attr = Attribute.new('foo')
        attr.name.should == :foo
      end

      should "have a default source" do
        attr = Attribute.new(:foo)
        attr.sources.should == ['foo']
      end
      
      should "be able to assign multiple sources" do
        attr = Attribute.new(:foo, ['foo1', 'foo2'])
        attr.sources.should == ['foo1', 'foo2']
      end

      should "pull the location from the source" do
        attr = Attribute.new('foo')
        attr.location('foo').should == 'foo'
      end
      
      should "return the location when splitting" do
        attr = Attribute.new('foo')
        attr.split('foo').should == ['foo', nil]
      end
      
      should "return the name for the location when splitting if the location isn't specified" do
        attr = Attribute.new('foo')
        attr.split('@bar').should == ['foo', 'bar']
      end
      
      should "allow the setting of the location information" do
        attr = Attribute.new('foo', 'bar')
        attr.sources.should == ['bar']
      end
      
      should "allow the setting of the attribute value" do
        attr = Attribute.new('foo')
        attr.attribute('@bogon').should == 'bogon'
      end
      
      should "use the location as the attribute" do
        attr = Attribute.new('foo')
        attr.attribute('foo').should == 'foo'
      end
      
      should "use the attribute for the attribute if specified" do
        attr = Attribute.new(:id, '@nsid')
        attr.attribute('@nsid').should == 'nsid'
      end

      should "be able to retrieve the node from the path" do
        document = Hpricot.XML('<name>Bassdrive</name>')
        expected = document.at('name')
        
        attr = Attribute.new(:name)
        attr.node_for(document, 'name').should == expected
      end
      
      should "be able to retrieve the node that contains the specified attribute" do
        document = Hpricot.XML('<user id="1337" />')
        expected = document.at('user')
        
        attr = Attribute.new(:id)
        attr.node_for(document, '@id').should == expected
      end

      should "be able to retrieve the node for the specified attribute" do
        document = Hpricot.XML('<user nsid="1337" />')
        expected = document.at('user')
        
        attr = Attribute.new(:id, '@nsid')
        attr.node_for(document, '@nsid').should == expected
      end
      
      should "be able to pull simple values from an XML document" do
        document = Hpricot.XML('<name>Bassdrive</name>')
        attr = Attribute.new(:name)
        attr.value_from(document).should == 'Bassdrive'
      end

      should "be able to pull an attribute value from the current XML node" do
        document = Hpricot.XML('<user id="1337" />')
        attr = Attribute.new(:id)
        attr.value_from(document).should == '1337'
      end
        
      should "be able to pull a specific attribute value from the current XML node" do
        document = Hpricot.XML('<user nsid="1337" />')
        attr = Attribute.new(:id, '@nsid')
        attr.value_from(document).should  == '1337'
      end

      should "be able to pull an attribute value for a node and attribute" do
        document = Hpricot.XML('<station><genre slug="dnb">Drum & Bass</genre></station>')
        attr = Attribute.new(:slug, 'station/genre@slug')
        attr.value_from(document).should == 'dnb'
      end
        
      should "be able to pull a value from a nested XML node" do
        document = Hpricot.XML('<rsp><user>blip</user></rsp>')
        attr = Attribute.new(:user)
        attr.value_from(document).should == 'blip'
      end

      should "return nil if it cannot find the specified node" do
        document = Hpricot.XML('<user id="1" />')
        attr = Attribute.new(:photoset, '@nsid')
        attr.value_from(document).should be(nil)
      end

      should "be able to try a series of nodes to find a value" do
        document = Hpricot.XML('<photoid>123</photoid>')

        attr = Attribute.new(:id, ['photo@nsid', 'photoid'])
        attr.value_from(document).should == '123'
      end

    end
  end
end