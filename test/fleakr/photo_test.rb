require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class PhotoTest < Test::Unit::TestCase
    
    describe "The Photo class" do
      
      context "when finding all photos by photoset ID" do
        
        before do
          mock_request_cycle :for => 'photosets.getPhotos', :with => {:photoset_id => '1'}
          @photos = Photo.find_all_by_photoset_id('1')
        end  
      
        it "should have the correct number of items" do
          @photos.length.should == 2
        end
      
        it "should have the proper title" do
          @photos.map {|p| p.title}.should == ['Photo #1', 'Photo #2']
        end
        
        it "should have the proper id" do
          @photos.map {|p| p.id }.should == %w(3044163577 3045001128)
        end
      
      end
      
    end
    
  end
end