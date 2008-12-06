require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ImageTest < Test::Unit::TestCase

    def self.should_know_the_suffix_for(options)
      it "should know the suffix for the :#{options.keys.first} size" do
        Image.suffix_for(options.keys.first).should == options.values.first
      end
    end
    
    
    describe "The Image class" do
      
      should_know_the_suffix_for :square    => '_s.jpg'
      should_know_the_suffix_for :thumbnail => '_t.jpg'
      should_know_the_suffix_for :small     => '_m.jpg'
      should_know_the_suffix_for :medium    => '.jpg'
      should_know_the_suffix_for :large     => '_b.jpg'
      
    end
    
    describe "An instance of the Image class" do
      
      before do
        @base_filename = 'filename'
        @base_url      = "http://foo.bar/#{@base_filename}"
        @size          = :thumbnail

        @image = Image.new(@base_url, @size)
      end
      
      it "should know its full URL" do
        Image.stubs(:suffix_for).with(@size).returns('.jpg')
        @image.url.should == "#{@base_url}.jpg"
      end
      
      it "should know its filename" do
        Image.stubs(:suffix_for).with(@size).returns('.jpg')
        @image.filename.should == "#{@base_filename}.jpg"
      end
      
      context "when saving the file" do
        
        before do
          @tmp_dir = create_temp_directory
          
          @url = 'http://host.com/image.jpg'
          @image_filename = 'image.jpg'
          
          @image = Image.new('http://host/image', :thumbnail)
          @image.stubs(:url).with().returns(@url)
          @image.stubs(:filename).with().returns(@image_filename)
        end
        
        after do
          FileUtils.rm_rf(@tmp_dir)
        end
        
        should "be able to save to a directory with the original filename" do
          Net::HTTP.expects(:get).with(URI.parse(@url)).returns('image_data')
          
          @image.save_to(@tmp_dir)
          File.read("#{@tmp_dir}/image.jpg").should == 'image_data'
        end
        
        should "be able to save to a specified file" do
          Net::HTTP.expects(:get).with(URI.parse(@url)).returns('image_data')
          existing_file = "#{@tmp_dir}/existing_file.jpg"
          
          FileUtils.touch(existing_file)
          
          @image.save_to(existing_file)
          File.read(existing_file).should == 'image_data'
        end
        
      end

    end
    
  end
end