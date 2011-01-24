require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class TagTest < Test::Unit::TestCase

    context "The Tag class" do

      should_find_all :tags, :by => :photo_id, :call => 'tags.getListPhoto', :path => 'rsp/photo/tags/tag', :class => Tag
      should_find_all :tags, :by => :user_id, :call => 'tags.getListUser', :path => 'rsp/who/tags/tag', :class => Tag

    end

    context "An instance of the Tag class" do

      setup { @tag = Tag.new }

      context "when populating from the tags_getListPhoto XML data" do
        setup do
          @object = Tag.new(Hpricot.XML(read_fixture('tags.getListPhoto')).at('rsp/photo/tags/tag'))
        end

        should_have_a_value_for :id           => '1'
        should_have_a_value_for :author_id    => '15498419@N05'
        should_have_a_value_for :value        => 'stu72'
        should_have_a_value_for :raw          => 'stu 72'
        should_have_a_value_for :machine_flag => '0'

      end

      should "have an author" do
        @tag.stubs(:author_id).at_least_once.with().returns('1')
        User.expects(:find_by_id).with('1', {}).returns('user')

        @tag.author.should == 'user'
      end

      should "pass options through to the author association" do
        @tag.stubs(:author_id).at_least_once.with().returns('1')
        User.expects(:find_by_id).with('1', :key => 'value').returns('user')

        @tag.author(:key => 'value').should == 'user'
      end

      should "pass authentication options through when fetching the author" do
        @tag.stubs(:author_id).at_least_once.with().returns('1')
        @tag.stubs(:authentication_options).with().returns(:auth_token => 'toke')

        User.expects(:find_by_id).with('1', :key => 'value', :auth_token => 'toke').returns('user')

        @tag.author(:key => 'value').should == 'user'
      end

      should "return nil for author if author_id is not present" do
        @tag.expects(:author_id).with().returns(nil)

        @tag.author.should be(nil)
      end

      should "have related tags" do
        @tag.expects(:value).with().returns('foo')

        response = mock_request_cycle :for => 'tags.getRelated', :with => {:tag => 'foo'}

        stubs = []
        elements = (response.body/'rsp/tags/tag').map

        elements.each do |element|
          stub = stub()
          stubs << stub

          Tag.expects(:new).with(element).returns(stub)
        end

        @tag.related.should == stubs
      end

      should "memoize the data for related tags" do
        @tag.expects(:value).with().returns('foo')

        mock_request_cycle :for => 'tags.getRelated', :with => {:tag => 'foo'}

        2.times { @tag.related }
      end

      should "be able to generate a string representation of itself" do
        @tag.expects(:value).with().returns('foo')
        @tag.to_s.should == 'foo'
      end

      should "know that it is not a machine tag" do
        @tag.expects(:machine_flag).with().returns('0')
        @tag.machine?.should be(false)
      end

      should "know that it is a machine tag" do
        @tag.expects(:machine_flag).with().returns('1')
        @tag.machine?.should be(true)
      end

    end

  end
end