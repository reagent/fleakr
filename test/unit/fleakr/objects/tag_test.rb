require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class TagTest < Test::Unit::TestCase

    describe "The Tag class" do
      
      should_find_all :tags, :by => :photo_id, :call => 'tags.getListPhoto', :path => 'rsp/photo/tags/tag'
      
    end
    
    describe "An instance of the Tag class" do
      
      context "when populating from the tags_getListPhoto XML data" do
        before do
          @object = Tag.new(Hpricot.XML(read_fixture('tags.getListPhoto')).at('rsp/photo/tags/tag'))
        end
        
        should_have_a_value_for :id => '1'
        should_have_a_value_for :author_id => '15498419@N05'
        should_have_a_value_for :value => 'stu72'
        
      end
      
    end
    
  end
end