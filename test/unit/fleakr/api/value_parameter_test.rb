require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ValueParameterTest < Test::Unit::TestCase

   context "An instance of the ValueParameter class" do
      
     should "have a value" do
       parameter = ValueParameter.new('foo', 'bar')
       parameter.value.should == 'bar'
     end
      
      should "know how to generate the query representation of itself" do
        parameter = ValueParameter.new('foo', 'bar')
        parameter.to_query.should == 'foo=bar'
      end
      
      should "escape the value when generating the query representation" do
        parameter = ValueParameter.new('foo', 'Mr. Crystal?')
        parameter.to_query.should == 'foo=Mr.+Crystal%3F'
      end
      
      should "use an empty string when generating a query if the parameter value is nil" do
        parameter = ValueParameter.new('foo', nil)
        parameter.to_query.should == 'foo='
      end
      
      should "know how to generate the form representation of itself" do
        parameter = ValueParameter.new('foo', 'bar')
        expected = 
          'Content-Disposition: form-data; name="foo"' + "\r\n" +
          "\r\n" +
          "bar\r\n"
          
        parameter.to_form.should == expected
      end
   
   end
    
  end
end