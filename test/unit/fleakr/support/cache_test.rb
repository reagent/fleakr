require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Support
  class CacheTest < Test::Unit::TestCase

    context "An instance of the Cache class" do

      should "know the cache key" do
        cache = Cache.new
        cache.key_for({:user_id => '1', 'auth_token' => 'toke'}).should == 'auth_token_toke_user_id_1'
      end

      should "know the cache key when given an object" do
        user = Fleakr::Objects::User.new
        user.stubs(:id).with().returns(1)

        cache = Cache.new(user)
        cache.key_for({:auth_token => 'toke'}).should == 'fleakr_objects_user_1_auth_token_toke'
      end

      should "return the results of a call" do
        object = stub(:users => ['user'])
        cache = Cache.new
        cache.for({}) { object.users }.should == ['user']
      end

      should "cache the results of a call" do
        object = mock()
        object.expects(:users).once.returns(['user'])

        cache = Cache.new

        cache.for({}) { object.users }
        cache.for({}) { object.users }
      end

      should "not have cached the results for a call with different options" do
        object = mock()
        object.expects(:users).twice.returns(['user'])

        cache = Cache.new

        cache.for({}) { object.users }
        cache.for({:auth_token => 'toke'}) { object.users }
      end

    end

  end
end