require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class CollectionTest < Test::Unit::TestCase

    context "The Collection class" do
      
      should_find_one :collections, :by => :id, :call => 'collections.getInfo', :path => 'rsp/collection'
      should_find_all :collections, :by => :user_id, :call => 'collections.getTree', :path => 'rsp/collections/collection'
      
    end

    context "An instance of the Collection class" do
      
      context "when populating from a call to collections.getInfo" do
        setup do
          document = Hpricot.XML(read_fixture('collections.getInfo')).at('rsp/collection')
          @object = Collection.new(document)
        end
        
        should_have_a_value_for :id             => '34762917-72157619347181335'
        should_have_a_value_for :title          => 'Work'
        should_have_a_value_for :description    => 'Sample Collection'
        should_have_a_value_for :large_icon_url => 'http://farm4.static.flickr.com/3603/cols/72157619347181335_30d89a2682_l.jpg'
        should_have_a_value_for :small_icon_url => 'http://farm4.static.flickr.com/3603/cols/72157619347181335_30d89a2682_s.jpg'
        should_have_a_value_for :created        => '1244460707'

      end
      
      context "when populating from a call to collections.getTree" do
        setup do
          document = Hpricot.XML(read_fixture('collections.getTree')).at('rsp/collections/collection')
          @object = Collection.new(document)
        end
        
        should_have_a_value_for :id             => '123-456'
        should_have_a_value_for :title          => 'Top-Level Collection 1'
        should_have_a_value_for :description    => 'Description 1'
        should_have_a_value_for :large_icon_url => 'http://farm4.static.flickr.com/3573/cols/72157617429277370_1691956f71_l.jpg'
        should_have_a_value_for :small_icon_url => 'http://farm4.static.flickr.com/3573/cols/72157617429277370_1691956f71_s.jpg'
        
      end
      
      context "that contains collections" do
        setup do
          document = Hpricot.XML(read_fixture('collections.getTree')).at('rsp/collections/collection')
          @collection = Collection.new(document)
        end
        
        should "have a set of collections" do
          collection_titles = @collection.collections.map {|c| c.title }
          collection_titles.should == ['Second-Level Collection 1']
        end
        
        should "not have any associated sets" do
          @collection.sets.should == []
        end
      end
      
      context "that contains sets" do
        setup do
          xml = <<-XML
            <collection id="123-102" title="Top-Level Collection 2" description="Description 5" iconlarge="http://farm4.static.flickr.com/3573/cols/72157617429277370_1691956f71_l.jpg" iconsmall="http://farm4.static.flickr.com/3573/cols/72157617429277370_1691956f71_s.jpg">	
          		<set id="1238" title="Set 5" description="" />
          		<set id="1239" title="Set 6" description="" />
            </collection>
          XML
        
          document = Hpricot.XML(xml).at('collection')
          @collection = Collection.new(document)
        end

        should "not have any associated collections" do
          @collection.collections.should == []
        end
        
        should "have associated sets" do
          set_titles = @collection.sets.map {|s| s.title }
          set_titles.should == ['Set 5', 'Set 6']
        end
        
      end
      
      context "in general" do
        setup do
          @collection = Collection.new
          @time       = Time.parse('2008-08-01 00:00:00')
        end
        
        should "have a value for :created_at" do
          @collection.expects(:created).with().returns("#{@time.to_i}")
          @collection.created_at.to_s.should == @time.to_s
        end
        
      end
    end

  end
end
