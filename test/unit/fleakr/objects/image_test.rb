require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ImageTest < Test::Unit::TestCase

    context "The Image class" do

      should_find_all :images, :by => :photo_id, :call => 'photos.getSizes', :path => 'sizes/size'

    end

    context "An instance of the Image class" do

      context "when populating the object from an XML document" do

        setup do
          @object = Image.new(Hpricot.XML(read_fixture('photos.getSizes')).at('sizes/size'))
        end

        should_have_a_value_for :size   => 'Square'
        should_have_a_value_for :width  => '75'
        should_have_a_value_for :height => '75'
        should_have_a_value_for :url    => 'http://farm4.static.flickr.com/3093/2409912100_71e14ed08a_s.jpg'
        should_have_a_value_for :page   => 'http://www.flickr.com/photos/the_decapitator/2409912100/sizes/sq/'

      end

      context "in general" do

        should "know its filename" do
          image = Image.new
          image.stubs(:url).with().returns('http://flickr.com/photos/foobar.jpg')

          image.filename.should == 'foobar.jpg'
        end

        context "when saving the file" do

          setup do
            @tmp_dir = create_temp_directory

            @url = 'http://host.com/image.jpg'
            @image_filename = 'image.jpg'

            @image = Image.new
            @image.stubs(:url).with().returns(@url)
            @image.stubs(:filename).with().returns(@image_filename)
            
            @image_data = 'image_data'
            Net::HTTP.expects(:get).with(URI.parse(@url)).returns(@image_data)
          end

          teardown do
            FileUtils.rm_rf(@tmp_dir)
          end

          should "be able to save to a directory with the original filename" do
            @image.save_to(@tmp_dir)
            File.read("#{@tmp_dir}/image.jpg").should == @image_data
          end

          should "be able to save to a specified file" do
            existing_file = "#{@tmp_dir}/existing_file.jpg"

            FileUtils.touch(existing_file)

            @image.save_to(existing_file)
            File.read(existing_file).should == @image_data
          end
          
          should "be able to save the file using a specified prefix" do
            @image.save_to(@tmp_dir, '001_')
            File.read("#{@tmp_dir}/001_image.jpg").should == @image_data
          end

        end
      end
    end

  end
end