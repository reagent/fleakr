require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class MetadataTest < Test::Unit::TestCase

    context "The Metadata class" do
      should_find_all :metadata, :class => Metadata, :by => :photo_id, :call => 'photos.getExif', :path => 'rsp/photo/exif'
    end

    context "An instance of the Metadata class" do

      context "when populating from the photos_getExif XML data" do
        setup do
          @object = Metadata.new(Hpricot.XML(read_fixture('photos.getExif')).at('rsp/photo/exif'))
        end

        should_have_a_value_for :tagspace => 'System'
        should_have_a_value_for :tag      => 'FileName'
        should_have_a_value_for :label    => 'FileName'
        should_have_a_value_for :raw      => 'ORI9141194487814365231.img'

      end

    end

  end
end