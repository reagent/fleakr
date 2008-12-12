require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class PhotoTest < Test::Unit::TestCase

    should_have_many :images

    describe "The Photo class" do

      should_find_all :photos, :by => :user_id, :call => 'people.getPublicPhotos', :path => 'rsp/photos/photo'
      should_find_all :photos, :by => :photoset_id, :call => 'photosets.getPhotos', :path => 'rsp/photoset/photo'

    end

    describe "An instance of the Photo class" do
      context "when populating from an XML document" do
        before do
          @object = Photo.new(Hpricot.XML(read_fixture('people.getPublicPhotos')).at('rsp/photos/photo'))
        end

        should_have_a_value_for :id        => '2924549350'
        should_have_a_value_for :title     => 'Photo #1'
        should_have_a_value_for :farm_id   => '4'
        should_have_a_value_for :server_id => '3250'
        should_have_a_value_for :secret    => 'cbc1804258'

      end
      
      context "in general" do
        
        it "should have a collection of images by size" do
          photo = Photo.new
          
          small_image, large_image = [stub(:size => 'Small'), stub(:size => 'Large')]
          
          photo.stubs(:images).returns([small_image, large_image])
          
          expected = {
            :square    => nil,
            :thumbnail => nil,
            :small     => small_image, 
            :medium    => nil,
            :large     => large_image,
            :original  => nil
          }
          
          photo.send(:images_by_size).should == expected
        end
        
        [:square, :thumbnail, :small, :medium, :large, :original].each do |method|
          it "should have a reader for the :#{method} image" do
            photo = Photo.new
            image = stub()
            
            photo.stubs(:images_by_size).returns(method => image)
            photo.send(method).should == image
          end
        end
        
        
      end
    end

    # context "in general" do
    # 
    #   before do
    #     @photo = Photo.new
    # 
    #     @photo.stubs(:id).with().returns('1')
    #     @photo.stubs(:farm_id).with().returns('2')
    #     @photo.stubs(:server_id).with().returns('3')
    #     @photo.stubs(:secret).with().returns('secret')
    #   end
    # 
    #   it "should know the base URL to retrieve images" do
    #     @photo.send(:base_url).should == "http://farm2.static.flickr.com/3/1_secret"
    #   end
    # 
    # end

    # context "with a base URL" do
    # 
    #   before do
    #     @photo = Photo.new
    #     @photo.stubs(:base_url).with().returns('url')
    #   end
    # 
    #   [:square, :thumbnail, :small, :medium, :large].each do |size|
    #     it "should have a :#{size} image" do
    #       image = stub()
    #       Image.expects(:new).with('url', size).returns(image)
    #       
    #       @photo.send(size).should == image
    #     end
    #   end
    # 
    # end
  end

end
