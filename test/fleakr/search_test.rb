require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SearchTest < Test::Unit::TestCase
    
    describe "An instance of the Search class" do
      
      it "should be able to search photos based on tags" do
        response = mock_request_cycle :for => 'photos.search', :with => {:tags => 'one,two'}
        
        photo_1, photo_2 = [stub(), stub()]
        photo_1_doc, photo_2_doc = (response.body/'rsp/photos/photo').map {|doc| doc }

        Photo.expects(:new).with(photo_1_doc).returns(photo_1)
        Photo.expects(:new).with(photo_2_doc).returns(photo_2)

        search = Search.new(:tags => %w(one two))
        search.results.should == [photo_1, photo_2]
      end
      
      
    end
    
  end
end