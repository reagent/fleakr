require File.dirname(__FILE__) + '/../../../test_helper'

class EmptyObject
  include Fleakr::Support::Object
end

class FlickrObject
  
  include Fleakr::Support::Object
  
  flickr_attribute :name
  flickr_attribute :description, :from => 'desc'
  flickr_attribute :id, :from => '@nsid'
  flickr_attribute :photoset_id, :from => 'photoset@id'
  flickr_attribute :tag, :category
  
  find_one :by_id, :call => 'people.getInfo'
  
end

module Fleakr
  class ObjectTest < Test::Unit::TestCase
    
    context "A class method provided by the Flickr::Object module" do
   
      should "have an empty list of attributes if none are supplied" do
        EmptyObject.attributes.should == []
      end
      
      should "know the names of all its attributes" do
        FlickrObject.attributes.map {|a| a.name.to_s }.should == %w(name description id photoset_id tag category)
      end
      
      should "be able to find by ID" do
        id = 1
        flickr_object = stub()
        
        response = mock_request_cycle :for => 'people.getInfo', :with => {:id => id}
        FlickrObject.expects(:new).with(response.body, :id => id).returns(flickr_object)
        
        FlickrObject.find_by_id(id).should == flickr_object
      end
      
      should "be able to pass parameters to the :find_by_id method" do
        id            = 1
        params        = {:authenticate? => true}
        full_params   = {:id => id, :authenticate? => true}
        flickr_object = stub()

        response = mock_request_cycle :for => 'people.getInfo', :with => full_params
        FlickrObject.expects(:new).with(response.body, full_params).returns(flickr_object)
        
        FlickrObject.find_by_id(id, params).should == flickr_object
      end
      
    end
    
    context "An instance method provided by the Flickr::Object module" do
      
      should "have default reader methods" do
        [:name, :description, :id, :photoset_id, :tag, :category].each do |method_name|
          FlickrObject.new.respond_to?(method_name).should == true
        end
      end
      
      should "be able to capture the :auth_token from options sent along to the new object" do
        object = EmptyObject.new(nil, {:foo => 'bar', :auth_token => 'toke'})
        object.authentication_options.should == {:auth_token => 'toke'}
      end
      
      context "when populating data from an XML document" do
        setup do
          xml = <<-XML
            <name>Fleakr</name>
            <desc>Awesome</desc>
            <photoset id="1" />
            <tag>Tag</tag>
            <category>Category</category>
          XML

          @document = Hpricot.XML(xml)

          @object = FlickrObject.new
          @object.populate_from(@document)
        end
        
        should "have the correct value for :name" do
          @object.name.should == 'Fleakr'
        end
        
        should "have the correct value for :description" do
          @object.description.should == 'Awesome'
        end
        
        should "have the correct value for :photoset_id" do
          @object.photoset_id.should == '1'
        end
        
        should "have the correct value for :id" do
          document = Hpricot.XML('<object nsid="1" />').at('object')
          @object.populate_from(document)
          
          @object.id.should == '1'
        end
        
        should "have the correct value for :tag" do
          @object.tag.should == 'Tag'
        end
        
        should "have the correct value for :category" do
          @object.category.should == 'Category'
        end
        
        should "maintain a reference to the original document" do
          @object.document.should == @document
        end
      end
      
      should "populate its data from an XML document when initializing" do
        document = stub()
        FlickrObject.any_instance.expects(:populate_from).with(document)
        
        FlickrObject.new(document)
      end
      
      should "not attempt to populate itself from an XML document if one is not available" do
        FlickrObject.any_instance.expects(:populate_from).never
        FlickrObject.new
      end
      
      should "not overwrite existing attributes when pulling in a partial new XML document" do
        object = FlickrObject.new(Hpricot.XML('<name>Fleakr</name>'))
        object.populate_from(Hpricot.XML('<desc>Awesome</desc>'))
        
        object.name.should == 'Fleakr'
      end
      
    end
    
  end
end