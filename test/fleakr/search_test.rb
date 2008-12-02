require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SearchTest < Test::Unit::TestCase
    
    describe "An instance of the Search class" do

      it "should be able to generate a list of tags from a single-valued parameter" do
        search = Search.new(nil, :tags => 'foo')
        search.tag_list.should == 'foo'
      end
      
      it "should be able to generate a list of tags from multi-valued parameters" do
        search = Search.new(nil, :tags => %w(foo bar))
        search.tag_list.should == 'foo,bar'
      end
      
      it "should be able to create parameters for the search" do
        search = Search.new(nil, :tags => %w(foo bar))
        search.parameters.should == {:tags => 'foo,bar'}
      end
      
      it "should not have any :tags parameters if none are supplied" do
        search = Search.new
        search.parameters.should == {}
      end
      
      it "should convert the search term into the appropriate parameter" do
        search = Search.new('foo')
        search.parameters.should == {:text => 'foo'}
      end
      
      it "should be able to search photos based on text" do
        response = mock_request_cycle :for => 'photos.search', :with => {:text => 'foo'}
        search = Search.new('foo')
        search.results
      end
      
      it "should be able to search photos based on tags" do
        response = mock_request_cycle :for => 'photos.search', :with => {:tags => 'one,two'}
        
        photo_1, photo_2 = [stub(), stub()]
        photo_1_doc, photo_2_doc = (response.body/'rsp/photos/photo').map {|doc| doc }
      
        Photo.expects(:new).with(photo_1_doc).returns(photo_1)
        Photo.expects(:new).with(photo_2_doc).returns(photo_2)
      
        search = Search.new(nil, :tags => %w(one two))
        search.results.should == [photo_1, photo_2]
      end
      
      should "memoize the search results" do
        response = stub(:body => Hpricot.XML(read_fixture('photos.search')))
        Request.expects(:with_response!).with(kind_of(String), kind_of(Hash)).once.returns(response)
        
        (response.body/'rsp/photos/photo').each do |doc|
          Photo.expects(:new).with(doc).once
        end
        
        search = Search.new(nil, :tags => %w(foo))
        
        2.times { search.results }
      end
      
      
    end
    
  end
end