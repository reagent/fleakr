require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class CommentTest < Test::Unit::TestCase

    context "The Comment class" do

      should_find_all :comments, :by => :photo_id, :call => 'photos.comments.getList', :path => 'rsp/comments/comment', :class => Comment
      should_find_all :comments, :by => :set_id, :using => :photoset_id, :call => 'photosets.comments.getList', :path => 'rsp/comments/comment', :class => Comment

    end

    context "An instance of the Comment class" do

      context "when populating from the photos_comments_getList XML data" do
        setup do
          @object = Comment.new(Hpricot.XML(read_fixture('photos.comments.getList')).at('rsp/comments/comment'))
        end

        should_have_a_value_for :id        => '1'
        should_have_a_value_for :author_id => '10490170@N04'
        should_have_a_value_for :created   => '1239217523'
        should_have_a_value_for :url       => 'http://www.flickr.com/photos/frootpantz/3422268412/#comment72157616515348062'
        should_have_a_value_for :body      => 'comment one'

      end

      context "in general" do

        setup { @comment = Comment.new }

        should "have a value for :created_at" do
          @comment.expects(:created).with().returns('1239217523')
          Time.expects(:at).with(1239217523).returns('time')

          @comment.created_at.should == 'time'
        end

        should "use the body as the string representation" do
          @comment.expects(:body).with().returns('bod')
          @comment.to_s.should == 'bod'
        end

        should "be able to find the author of the comment" do
          author = stub()

          @comment.stubs(:author_id).with().returns('1')
          User.stubs(:find_by_id).with('1', {}).returns(author)

          @comment.author.should == author
        end

        should "pass authentication credentials through when finding the author for a comment" do
          author = stub()

          @comment.stubs(:author_id).with().returns('1')
          @comment.stubs(:authentication_options).with().returns(:auth_token => 'toke')
          User.expects(:find_by_id).with('1', :key => 'value', :auth_token => 'toke').returns(author)

          @comment.author(:key => 'value').should == author
        end

      end
    end

  end
end