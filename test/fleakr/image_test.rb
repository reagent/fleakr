require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
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
      
    end
    
  end
end