require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Support
  class AssociationTest < Test::Unit::TestCase

    context "An instance of the Association class" do

      should "know the target class" do
        association = Association.new(stub(), :photos)
        association.target_class.should == Fleakr::Objects::Photo
      end

      should "know the target class when the optional type is provided" do
        association = Association.new(stub(), :private_photos, :photo)
        association.target_class.should == Fleakr::Objects::Photo
      end

      should "know the attribute name by which to scope" do
        user = Fleakr::Objects::User.new
        association = Association.new(user, :photos)

        association.scope_attribute.should == 'user_id'
      end

      should "know the finder method on the association" do
        user = Fleakr::Objects::User.new
        association = Association.new(user, :photos)

        association.finder_method.should == :find_all_by_user_id
      end

      should "know the finder method on the association when given a different type" do
        user        = Fleakr::Objects::User.new
        association = Association.new(user, :private_photos, :photo)

        association.finder_method.should == :find_all_private_photos_by_user_id
      end

      should "be able to get the cached results for a call" do
        user = Fleakr::Objects::User.new
        user.stubs(:id).returns('1')

        association = Association.new(user, :photos)

        Fleakr::Objects::Photo.
          expects(:find_all_by_user_id).
          once.
          with('1', :key => 'value').
          returns(['photo'])

        association.results(:key => 'value').should == ['photo']
        association.results(:key => 'value').should == ['photo']
      end

    end

  end
end
