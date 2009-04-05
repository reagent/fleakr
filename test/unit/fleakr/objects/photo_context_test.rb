require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class PhotoContextTest < Test::Unit::TestCase
    
    describe "An instance of the PhotoContext class" do
      
      before { @context = PhotoContext.new }
      
      context "when populating from the photos_getContext XML data" do
        before do
          @object = PhotoContext.new(Hpricot.XML(read_fixture('photos.getContext')))
        end
        
        should_have_a_value_for :count       => '5584'
        should_have_a_value_for :next_id     => '12343'
        should_have_a_value_for :previous_id => '12345'

      end
      
      it "should know that there is a previous photo" do
        @context.expects(:previous_id).with().returns('1')
        @context.previous?.should be(true)
      end
      
      it "should know that there isn't a previous photo" do
        @context.expects(:previous_id).with().returns('0')
        @context.previous?.should be(false)
      end
      
      it "should know that there is a next photo" do
        @context.expects(:next_id).with().returns('1')
        @context.next?.should be(true)
      end
      
      it "should know that there isn't a next photo" do
        @context.expects(:next_id).with().returns('0')
        @context.next?.should be(false)
      end
      
      it "should find the previous photo" do
        photo = stub()
        
        @context.expects(:previous_id).with().returns('1')
        @context.expects(:previous?).with().returns(true)
        
        Photo.expects(:find_by_id).with('1').returns(photo)
        
        @context.previous.should == photo
      end
      
      it "should not try to find the previous photo if it doesn't exist" do
        @context.expects(:previous?).with().returns(false)
        Photo.expects(:find_by_id).never
        
        @context.previous.should be(nil)
      end
      
      it "should find the next photo" do
        photo = stub()
        @context.expects(:next_id).with().returns('1')
        @context.expects(:next?).with().returns(true)
                
        Photo.expects(:find_by_id).with('1').returns(photo)
        
        @context.next.should == photo
      end
      
      it "should not try to find the next photo if it doesn't exist" do
        @context.expects(:next?).with().returns(false)
        Photo.expects(:find_by_id).never
        
        @context.next.should be(nil)
      end
      
      
    end
    
  end
end