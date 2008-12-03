require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class GroupTest < Test::Unit::TestCase

    describe "The Group class" do
      
      should_find_all :groups, :by => :user_id, :call => 'people.getPublicGroups', :path => 'rsp/groups/group'
      
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