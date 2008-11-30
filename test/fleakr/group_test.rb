require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class GroupTest < Test::Unit::TestCase

    describe "The Group class" do
      
      it "should be able to find all groups by user ID" do
        user_id = 'ABC123'
        group_1, group_2 = [stub(), stub()]

        response = mock_request_cycle :for => 'people.getPublicGroups', :with => {:user_id => user_id}

        group_1_doc, group_2_doc = (response.body/'rsp/groups/group').map {|doc| doc }

        Group.expects(:new).with(group_1_doc).returns(group_1)
        Group.expects(:new).with(group_2_doc).returns(group_2)

        Group.find_all_by_user_id(user_id).should == [group_1, group_2]
      end

    end
    
    describe "An instance of the Group class" do
      context "when initializing from an Hpricot document" do
        
        before do
          doc = (Hpricot.XML(read_fixture('people.getPublicGroups'))/'rsp/groups/group').first
          @group = Group.new(doc)
        end
      
        it "should have a value for :id" do
          @group.id.should == '13378274@N00'
        end
        
        it "should have a value for :name" do
          @group.name.should == 'Group #1'
        end
        
      end
    end
    
  end
end