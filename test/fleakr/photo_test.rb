require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class PhotoTest < Test::Unit::TestCase

    describe "The Photo class" do

      should_find_all :photos, :by => :user_id, :call => 'people.getPublicPhotos', :path => 'rsp/photos/photo'
      should_find_all :photos, :by => :photoset_id, :call => 'photosets.getPhotos', :path => 'rsp/photoset/photo'

    end

    describe "An instance of the Photo class" do
      context "when populating from an XML document" do
        before do
          @object = Photo.new(Hpricot.XML(read_fixture('people.getPublicPhotos')).at('rsp/photos/photo'))
        end

        should_have_a_value_for :id    => '2924549350'
        should_have_a_value_for :title => 'Photo #1'

      end
    end
    
  end
end