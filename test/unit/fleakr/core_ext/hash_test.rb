require File.dirname(__FILE__) + '/../../../test_helper'

class HashTest < Test::Unit::TestCase
  
  context "An instance of Hash" do
    context "when extracting key/value pairs" do
      
      setup do
        @hash = {:one => 'two', :three => 'four'}
      end
      
      should "return a hash with the matching key/value pairs" do
        @hash.extract!(:one).should == {:one => 'two'}
      end
      
      should "return an empty hash if the key isn't found" do
        @hash.extract!(:foo).should == {}
      end
      
      should "alter the original hash when a value is extracted" do
        @hash.extract!(:one)
        @hash.should == {:three => 'four'}
      end
      
      should "be able to extract multiple keys" do
        @hash.extract!(:one, :three, :missing).should == {:one => 'two', :three => 'four'}
      end
      
    end
  end
  
end