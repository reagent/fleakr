require File.dirname(__FILE__) + '/../test_helper'

module Fleakr
  class UserTest < Test::Unit::TestCase

    def self.should_have_an_accessor_for(*attributes)
      attributes.each do |attribute|
        it "should have an accessor for :#{attribute}" do
          user = User.new
          user.send("#{attribute}=".to_sym, 'foo')
          user.send(attribute.to_sym).should == 'foo'
        end
      end
    end
    
    describe "The User class" do
      
      it "should be able to find a user by his username" do
        response = stub() {|s| s.stubs(:values_for).with(:user).returns('nsid' => '69') }
        user = stub()
        
        Request.expects(:new).with('people.findByUsername', :username => 'foobar').returns(mock(:send => response))
        User.expects(:new).with('nsid' => '69').returns(user)
        
        User.find_by_username('foobar').should == user
      end
      
    end
    
    describe "An instance of User" do

      should_have_an_accessor_for :nsid, :username, :id
      
      it "should be able to bulk-assign attributes" do
        user = User.new
        user.expects(:foo=).with('bar')
        
        user.set_attributes('foo' => 'bar')
      end
      
      it "should not try to set an attribute on the class that doesn't exist" do
        user = User.new
        lambda { user.set_attributes('foo' => 'bar') }.should_not raise_error
      end
      
      it "should set the attributes on initialization" do
        attributes = {'nsid' => '69', 'username' => 'foobar'}
        User.any_instance.expects(:set_attributes).with(attributes)
        
        user = User.new(attributes)
      end
      
    end
    
  end
end