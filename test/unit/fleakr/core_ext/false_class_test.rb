require File.dirname(__FILE__) + '/../../../test_helper'

class FalseClassTest < Test::Unit::TestCase
  
  context "An instance of the FalseClass class" do
    
    should "have 0 as its integer value" do
      false.to_i.should == 0
    end
    
  end
  
end
