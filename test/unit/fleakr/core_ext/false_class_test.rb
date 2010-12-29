require File.expand_path('../../../../test_helper', __FILE__)

class FalseClassTest < Test::Unit::TestCase

  context "An instance of the FalseClass class" do

    should "have 0 as its integer value" do
      false.to_i.should == 0
    end

  end

end
