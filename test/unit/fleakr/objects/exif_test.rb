require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ExifTest < Test::Unit::TestCase

    context "The Exif class" do
      should_find_all :exifs, :by => :photo_id, :call => 'photos.getExif', :path => 'rsp/photo/exif'
    end
    
    context "An instance of the Exif class" do
      
      setup { @exif = Exif.new }
      
      context "when populating from the photos_getExif XML data" do
        setup do
          @object = Exif.new(Hpricot.XML(read_fixture('photos.getExif')).at('rsp/photo/exif'))
        end
        
        should_have_a_value_for :tagspace           => 'System'
        should_have_a_value_for :tag        => 'FileName'
        should_have_a_value_for :label          => 'FileName'
        should_have_a_value_for :raw => 'ORI9141194487814365231.img'

      end

    end
    
  end
end