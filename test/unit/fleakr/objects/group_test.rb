require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class GroupTest < Test::Unit::TestCase

    should_have_many :photos
    
    should_search_by :group_id

    context "The Group class" do
      
      should_find_all :groups, :by => :user_id, :call => 'people.getPublicGroups', :path => 'rsp/groups/group'
      
    end
    
    context "An instance of the Group class" do
      context "when initializing from an Hpricot document" do
        
        setup do
          doc = Hpricot.XML(read_fixture('people.getPublicGroups')).at('rsp/groups/group')
          @object = Group.new(doc)
        end
        
        should_have_a_value_for :id   => '13378274@N00'
        should_have_a_value_for :name => 'Group #1'
        should_have_a_value_for :adult_flag => '1'
        
      end

      should "know that the group is adult-only" do
        group = Group.new
        group.stubs(:adult_flag).with().returns('1')
        group.adult?.should be(true)
      end
      
      should "know that the group is not adult-only" do
        group = Group.new
        group.stubs(:adult_flag).with().returns('0')
        group.adult?.should be(false)
      end
      
    end
    
  end
end

