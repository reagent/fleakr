require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class PhotoTest < Test::Unit::TestCase
    
    describe "The Photo class" do
      
      it "should be able to find all photos by user ID" do
        response = mock_request_cycle :for => 'people.getPublicPhotos', :with => {:user_id => '1'}
        
        photo_1, photo_2 = [stub(), stub()]
        photo_1_doc, photo_2_doc = (response.body/'rsp/photos/photo').map
        
        Photo.expects(:new).with(photo_1_doc).returns(photo_1)
        Photo.expects(:new).with(photo_2_doc).returns(photo_2)
        
        Photo.find_all_by_user_id('1').should == [photo_1, photo_2]
      end
      
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