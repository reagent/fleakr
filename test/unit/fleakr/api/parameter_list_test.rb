require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ParameterListTest < Test::Unit::TestCase
    
    describe "An instance of the ParameterList class" do
      
      before do
        @api_key = 'key'
        @secret  = 'foobar'

        Fleakr.stubs(:shared_secret).with().returns(@secret)
        Fleakr.stubs(:api_key).with().returns(@api_key)
        @parameter_list = ParameterList.new
      end
      
      it "should contain the :api_key by default" do
        @parameter_list[:api_key].name.should == 'api_key'
        @parameter_list[:api_key].value.should == @api_key
        @parameter_list[:api_key].include_in_signature?.should be(true)
      end
      
      it "should be able to create an initial list of parameters" do
        parameter_list = ParameterList.new(:one => 'two')
        parameter_list[:one].value.should == 'two'
      end

      it "should be able to add parameters to its list" do
        parameter = ValueParameter.new('foo', 'bar')
        
        @parameter_list << parameter
        @parameter_list['foo'].should == parameter
      end
      
      it "should allow access to parameters by symbol" do
        parameter = ValueParameter.new('foo', 'bar')
        @parameter_list << parameter
        
        @parameter_list[:foo].should == parameter
      end
      
      it "should overwrite existing values when a duplicate is added" do
        length = @parameter_list.instance_variable_get(:@list).length
        2.times {@parameter_list << ValueParameter.new('foo', 'bar') }
        
        @parameter_list.instance_variable_get(:@list).length.should == length + 1
      end
      
      it "should be able to calculate the signature of the parameters" do
        @parameter_list << ValueParameter.new('foo', 'bar')
        @parameter_list.signature.should == Digest::MD5.hexdigest("#{@secret}api_key#{@api_key}foobar")
      end
      
      it "should use the correct order when signing a list of multiple parameters" do
        @parameter_list << ValueParameter.new('z', 'a')
        @parameter_list << ValueParameter.new('a', 'z')
        
        @parameter_list.signature.should == Digest::MD5.hexdigest("#{@secret}azapi_key#{@api_key}za")
      end
      
      it "should ignore the parameters that aren't included in the signature" do
        @parameter_list << ValueParameter.new('foo', 'bar')
        @parameter_list << ValueParameter.new('yes', 'no', false)
        
        @parameter_list.signature.should == Digest::MD5.hexdigest("#{@secret}api_key#{@api_key}foobar")
      end
      
      it "should be able to generate a boundary for post data" do
        rand = '0.123'
        
        @parameter_list.stubs(:rand).with().returns(stub(:to_s => rand))
        @parameter_list.boundary.should == Digest::MD5.hexdigest(rand)
      end
      
      it "should know that it doesn't need to sign the request by default" do
        @parameter_list.sign?.should be(false)
      end
      
      it "should know that it needs to sign the request when asked" do
        parameter_list = ParameterList.new(:sign? => true)
        parameter_list.sign?.should be(true)
      end
      
      it "should know that it doesn't need to authenticate the request by default" do
        @parameter_list.authenticate?.should be(false)
      end
      
      it "should know to authenticate the request when asked" do
        Fleakr.expects(:token).with().returns(stub(:value => 'toke'))
        
        parameter_list = ParameterList.new(:authenticate? => true)
        parameter_list.authenticate?.should be(true)
      end
      
      it "should contain the :auth_token parameter in the list if the request is to be authenticated" do
        Fleakr.expects(:token).with().returns(stub(:value => 'toke'))
        
        parameter_list = ParameterList.new(:authenticate? => true)
        auth_param = parameter_list[:auth_token]
        
        auth_param.name.should == 'auth_token'
        auth_param.value.should == 'toke'
        auth_param.include_in_signature?.should be(true)
      end
      
      it "should know that it needs to sign the request when it is to be authenticated" do
        Fleakr.expects(:token).with().returns(stub(:value => 'toke'))
        
        parameter_list = ParameterList.new(:authenticate? => true)
        parameter_list.sign?.should be(true)
      end
      
      it "should include the signature in the list of parameters if the request is to be signed" do
        parameter_list = ParameterList.new(:sign? => true)
        parameter_list.stubs(:signature).with().returns('sig')
        
        signature_param = parameter_list[:api_sig]
        
        signature_param.name.should == 'api_sig'
        signature_param.value.should == 'sig'
        signature_param.include_in_signature?.should be(false)
      end
      
      context "with associated parameters" do

        before do
          @p1 = ValueParameter.new('a', 'b')
          @p2 = ValueParameter.new('c', 'd')

          @p1.stubs(:to_query).with().returns('q1')
          @p1.stubs(:to_form).with().returns('f1')
          
          @p2.stubs(:to_query).with().returns('q2')
          @p2.stubs(:to_form).with().returns('f2')

          @parameter_list.stubs(:list).with().returns('a' => @p1, 'c' => @p2)
        end

        it "should be able to generate a query representation of itself" do
          @parameter_list.to_query.should == 'q1&q2'
        end

        it "should be able to represent a form representation of itself" do
          @parameter_list.stubs(:boundary).returns('bound')
          
          expected = 
            "--bound\r\n" +
            "f1" +
            "--bound\r\n" +
            "f2" +
            "--bound--"
            
          @parameter_list.to_form.should == expected
        end
        
      end
      
    end
    
  end
end