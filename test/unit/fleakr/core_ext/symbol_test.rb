require File.expand_path('../../../../test_helper', __FILE__)

class SymbolTest < Test::Unit::TestCase

  context "An instance of the Symbol class" do

    should "know it comes before another string" do
      (:a <=> 'b').should == -1
    end

    should "know that it's equal to a string" do
      (:a <=> 'a').should == 0
    end

    should "know that it comes after another string" do
      (:b <=> 'a').should == 1
    end

    should "know that it comes before another symbol" do
      (:a <=> :b).should == -1
    end

  end

end
