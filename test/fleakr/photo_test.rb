require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class PhotoTest < Test::Unit::TestCase
    
    describe "The Photo class" do
      
      should_find_all :photos, :by => :user_id, :call => 'people.getPublicPhotos', :path => 'rsp/photos/photo'
      should_find_all :photos, :by => :photoset_id, :call => 'photosets.getPhotos', :path => 'rsp/photoset/photo'
      
    end
    
  end
end