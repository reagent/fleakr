require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SetTest < Test::Unit::TestCase
    
    def mock_request_cycle(options)
      response = stub(:body => read_fixture(options[:for]))
      Request.expects(:new).with(options[:for], options[:with]).returns(stub(:send => response))
    end
    
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
        
      end
    end
  end
end
