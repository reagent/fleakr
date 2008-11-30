require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SetTest < Test::Unit::TestCase

    describe "The Set class" do
      context "When finding all sets for a user_id" do
        before do
          user_id = '31066442@N69'
          mock_request_cycle :for => 'photosets.getList', :with => {:user_id => user_id}

          @sets = Set.find_all_by_user_id(user_id)
        end

        it "should return an array with the expected number of elements" do
          @sets.length.should == 2
        end

        it "should have the proper titles for each set in the collection" do
          @sets.map {|s| s.title }.should == ["Second Set", "First Set"]
        end

        it "should have the proper descriptions for each set in the collection" do
          @sets.map {|s| s.description }.should == ['This is the second set.', 'This is the first set.']
        end

        it "should have the correct IDs for each of the sets" do
          @sets.map {|s| s.id }.should == %w(72157609490909659 72157608538140671)
        end

      end
    end

    describe "An instance of the Set class" do
      context "when accessing its list of photos" do
        
        before do
          @set = Set.new()
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
