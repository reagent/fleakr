require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class UrlTest < Test::Unit::TestCase

    context "An instance of the Url class" do

      should "know that it's not a shortened URL" do
        u = Url.new('http://flickr.com/photos/reagent/4041660453/')
        u.shortened?.should be(false)
      end

      should "know that it's a shortened URL" do
        u = Url.new('http://flic.kr/p/7a9yQV')
        u.shortened?.should be(true)
      end

      should "know the path for a shortened URL" do
        url = 'http://flic.kr/p/7a9yQV'

        Fleakr::Support::UrlExpander.stubs(:expand).with(url).returns('/expanded/path')

        u = Url.new(url)
        u.path.should == '/expanded/path'
      end

      should "now the path for a normal URL" do
        u = Url.new('http://www.flickr.com/photos/reagent/4041660453/')
        u.path.should == '/photos/reagent/4041660453/'
      end

      should "know the path when there is no hostname" do
        u = Url.new('http://flickr.com/photos/reagent/4041660453/')
        u.path.should == '/photos/reagent/4041660453/'
      end

      should "be able to retrieve a user from his photo URL" do
        u = Url.new('http://www.flickr.com/photos/reagent/')

        User.stubs(:find_by_url).with('http://www.flickr.com/photos/reagent/').returns('user')

        u.user.should == 'user'
      end

      should "be able to retrieve a user from his profile URL" do
        u = Url.new('http://www.flickr.com/people/reagent/')

        User.stubs(:find_by_url).with('http://www.flickr.com/people/reagent/').returns('user')

        u.user.should == 'user'
      end

      context "when provided a single photo URL" do
        subject { Url.new('http://flickr.com/photos/reagent/4041660453/') }

        should "know that it's retrieving a photo resource" do
          subject.resource_type.should == Photo
        end

        should "know the :user_identifier" do
          subject.user_identifier.should == 'reagent'
        end

        should "know the :resource_identifier" do
          subject.resource_identifier.should == '4041660453'
        end

        should "know that it's not retrieving a collection of resources" do
          subject.collection?.should be(false)
        end

        should "return the resource" do
          Fleakr::Objects::Photo.expects(:find_by_id).with('4041660453').returns('photo')
          subject.resource.should == 'photo'
        end
      end

      context "when provided with a photoset URL" do
        subject { @subject ||= Url.new('http://www.flickr.com/photos/reagent/') }

        should "know that it's retrieving a Photo resource" do
          subject.resource_type.should == Photo
        end

        should "know the :user_identifier" do
          subject.user_identifier.should == 'reagent'
        end

        should "not have a :resource_identifier" do
          subject.resource_identifier.should be_nil
        end

        should "know that it's retrieving a collection of resources" do
          subject.collection?.should be(true)
        end

        should "return the resource" do
          subject.stubs(:user).with().returns(stub(:id => '1'))

          Fleakr::Objects::Photo.expects(:find_all_by_user_id).with('1').returns('photos')
          subject.resource.should == 'photos'
        end

      end

      context "when provided with a profile URL" do
        subject { @subject ||= Url.new('http://www.flickr.com/people/reagent/') }

        should "know that it's retrieving a user resource" do
          subject.resource_type.should == User
        end

        should "know the :user_identifier" do
          subject.user_identifier.should == 'reagent'
        end

        should "not have a :resource_identifier" do
          subject.resource_identifier.should be_nil
        end

        should "return the resource" do
          subject.expects(:user).with().returns('user')
          subject.resource.should == 'user'
        end
      end

      context "when provided a profile URL with a user ID" do
        subject { Url.new('http://www.flickr.com/people/43955217@N05/') }

        should "know the :user_identifier" do
          subject.user_identifier.should == '43955217@N05'
        end

      end

      context "when provided with a single set URL" do
        subject { Url.new('http://www.flickr.com/photos/reagent/sets/72157622660138146/') }

        should "know that it's retrieving a set resource" do
          subject.resource_type.should == Set
        end

        should "know the :user_identifier" do
          subject.user_identifier.should == 'reagent'
        end

        should "know the :resource_identifier" do
          subject.resource_identifier.should == '72157622660138146'
        end

        should "return the resource" do
          Fleakr::Objects::Set.expects(:find_by_id).with('72157622660138146').returns('set')
          subject.resource.should == 'set'
        end
      end

      context "when provided a set listing URL" do
        subject { @subject ||= Url.new('http://www.flickr.com/photos/reagent/sets/') }

        should "know that it's retrieving a set resource" do
          subject.resource_type.should == Set
        end

        should "know the :user_identifier" do
          subject.user_identifier.should == 'reagent'
        end

        should "not have a :resource_identifier" do
          subject.resource_identifier.should be_nil
        end

        should "return the resource" do
          subject.stubs(:user).with().returns(stub(:id => '1'))

          Fleakr::Objects::Set.expects(:find_all_by_user_id).with('1').returns('sets')
          subject.resource.should == 'sets'
        end
      end

    end

  end
end
