require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class PhotoContextTest < Test::Unit::TestCase

    context "An instance of the PhotoContext class" do

      setup { @context = PhotoContext.new }

      context "when populating from the photos_getContext XML data" do
        setup do
          @object = PhotoContext.new(Hpricot.XML(read_fixture('photos.getContext')))
        end

        should_have_a_value_for :count       => '5584'
        should_have_a_value_for :next_id     => '12343'
        should_have_a_value_for :previous_id => '12345'

      end

      should "know that there is a previous photo" do
        @context.stubs(:previous_id).with().returns('1')
        @context.previous?.should be(true)
      end

      should "know that there isn't a previous photo" do
        @context.stubs(:previous_id).with().returns('0')
        @context.previous?.should be(false)
      end

      should "know that there is a next photo" do
        @context.stubs(:next_id).with().returns('1')
        @context.next?.should be(true)
      end

      should "know that there isn't a next photo" do
        @context.stubs(:next_id).with().returns('0')
        @context.next?.should be(false)
      end

      should "find the previous photo" do
        @context.stubs(:previous_id).with().returns('1')
        @context.stubs(:previous?).with().returns(true)

        Photo.stubs(:find_by_id).with('1', {}).returns('photo')

        @context.previous.should == 'photo'
      end

      should "pass authentication options when finding the previous photo" do
        @context.stubs(:previous_id).with().returns('1')
        @context.stubs(:previous?).with().returns(true)
        @context.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        Photo.stubs(:find_by_id).with('1', :auth_token => 'toke').returns('photo')

        @context.previous.should == 'photo'
      end

      should "not try to find the previous photo if it doesn't exist" do
        @context.expects(:previous?).with().returns(false)
        Photo.expects(:find_by_id).never

        @context.previous.should be(nil)
      end

      should "find the next photo" do
        @context.stubs(:next_id).with().returns('1')
        @context.stubs(:next?).with().returns(true)

        Photo.stubs(:find_by_id).with('1', {}).returns('photo')

        @context.next.should == 'photo'
      end

      should "paass authentication options when finding the next photo" do
        @context.stubs(:next_id).with().returns('1')
        @context.stubs(:next?).with().returns(true)
        @context.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        Photo.stubs(:find_by_id).with('1', :auth_token => 'toke').returns('photo')

        @context.next.should == 'photo'
      end

      should "not try to find the next photo if it doesn't exist" do
        @context.stubs(:next?).with().returns(false)
        Photo.stubs(:find_by_id).never

        @context.next.should be(nil)
      end

    end

  end
end