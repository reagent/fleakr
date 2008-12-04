require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class SetTest < Test::Unit::TestCase

    should_have_many :photos, :using => 'photoset_id'

    describe "The Set class" do
      
      should_find_all :sets, :by => :user_id, :call => 'photosets.getList', :path => 'rsp/photosets/photoset'
      
    end

    describe "An instance of the Set class" do
      
      context "when populating from an XML document" do
        before do
          @object = Set.new(Hpricot.XML(read_fixture('photosets.getList')).at('rsp/photosets/photoset'))
        end
        
        should_have_a_value_for :id          => '72157609490909659'
        should_have_a_value_for :title       => 'Second Set'
        should_have_a_value_for :description => 'This is the second set.'
        
      end
      
      context "when saving the set" do
        before do
          @tmp_dir = create_temp_directory
        end
        
        after { FileUtils.rm_rf(@tmp_dir) }
        
        it "should save all files of the specified size to the specified directory" do
          image = mock()
          image.expects(:save_to).with("#{@tmp_dir}/set")
          
          photo = stub(:small => image)
          
          set = Set.new
          set.stubs(:title).with().returns('set')
          set.stubs(:photos).with().returns([photo])
          
          FileUtils.expects(:mkdir).with("#{@tmp_dir}/set")
          
          set.save_to(@tmp_dir, :small)
        end
        
        it "should not create the directory if it already exists" do
          FileUtils.mkdir("#{@tmp_dir}/set")
          
          set = Set.new
          set.stubs(:title).with().returns('set')
          set.stubs(:photos).with().returns([])
          
          FileUtils.expects(:mkdir).with("#{@tmp_dir}/set").never
          
          set.save_to(@tmp_dir, :small)
        end
        
      end

    end

  end
end
