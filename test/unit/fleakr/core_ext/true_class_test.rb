require File.dirname(__FILE__) + '/../../../test_helper'

class TrueClassTest < Test::Unit::TestCase
  
  context "An instance of the TrueClass class" do
    
    should "have 1 as its integer value" do
      true.to_i.should == 1
    end
    
  end
  
end
