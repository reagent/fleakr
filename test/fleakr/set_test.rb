require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SetTest < Test::Unit::TestCase

    describe "The Set class" do
      
      should_find_all :sets, :by => :user_id, :call => 'photosets.getList', :path => 'rsp/photosets/photoset'
      
    end

    describe "An instance of the Set class" do
      context "when accessing its list of photos" do
        
        before do
          @set = Set.new
          @set.stubs(:id).with().returns('1')          
        end

        it "should retrieve a list of photos" do
          photos = [stub()]

          Photo.expects(:find_all_by_photoset_id).with('1').returns(photos)

          @set.photos.should == photos
        end
        
        it "should memoize the list of photos retrieved" do
          Photo.expects(:find_all_by_photoset_id).once.returns([])
          2.times { @set.photos }
        end
        
      end

    end

  end
end
