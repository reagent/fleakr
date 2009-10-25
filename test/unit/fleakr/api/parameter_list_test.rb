require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class ParameterListTest < Test::Unit::TestCase
    
    context "An instance of the ParameterList class with an available API key" do
      setup do
        @api_key_value = 'api_key_value'
        Fleakr.stubs(:api_key).with().returns(@api_key_value)
        
        @parameter_list = ParameterList.new
      end

      should "send the authentication token by default if it is available" do
        @parameter_list.stubs(:authentication_token).with().returns('toke')
        @parameter_list.send_authentication_token?.should be(true)
      end
      
      should "know not to send the authentication token" do
        pl = ParameterList.new({}, false)
        pl.stubs(:authentication_token).with().returns('toke')
        
        pl.send_authentication_token?.should be(false)
      end
      
      should "know not to send the authentication token if it's not available from the global value" do
        @parameter_list.stubs(:authentication_token).with().returns(nil)
        @parameter_list.send_authentication_token?.should be(false)
      end
      
      should "have a default list of options" do
        @parameter_list.default_options.should == {:api_key => @api_key_value}
      end
      
      should "use the authentication_token in the options if we're to authenticate" do
        @parameter_list.stubs(:send_authentication_token?).with().returns(true)
        @parameter_list.stubs(:authentication_token).with().returns('toke')
        @parameter_list.stubs(:default_options).with().returns({})
        
        @parameter_list.options.should == {:auth_token => 'toke'}
      end
      
      should "add additional options from the constructor" do
        pl = ParameterList.new(:foo => 'bar')
        pl.options.should == {:foo => 'bar', :api_key => @api_key_value}
      end
      
      should "know that it doesn't need to sign the request by default" do
        @parameter_list.sign?.should be(false)
      end
      
      should "know that it needs to sign the request when a shared secret is available" do
        Fleakr.expects(:shared_secret).with().returns('secrit')
        @parameter_list.sign?.should be(true)
      end
      
      should "be able to add an option to the list" do
        @parameter_list.stubs(:default_options).with().returns({})
        
        @parameter_list.add_option(:foo, 'bar')
        @parameter_list.options.should == {:foo => 'bar'}
      end
      
      should "have an empty list of upload options by default" do
        @parameter_list.upload_options.should == {}
      end
      
      should "be able to add an upload option to the list" do
        @parameter_list.add_upload_option(:file, '/path/to/foo')
        @parameter_list.upload_options.should == {:file => '/path/to/foo'}
      end
      
      should "be able to generate the list of parameters without a signature" do
        @parameter_list.stubs(:options).with().returns({:foo => 'bar', :api_sig => '1234'})
        @parameter_list.options_without_signature.should == {:foo => 'bar'}
      end
      
      should "be able to calculate the signature of the parameters" do
        Fleakr.stubs(:shared_secret).with().returns('sekrit')
        
        options = {:api_key => @api_key_value, :foo => 'bar', :blip => 'zeeez'}
        @parameter_list.stubs(:options_without_signature).with().returns(options)

        @parameter_list.signature.should == Digest::MD5.hexdigest("sekritapi_key#{@api_key_value}blipzeeezfoobar")
      end
      
      should "be able to generate a list of options with a signature" do
        parameters = [ValueParameter.new('foo', 'bar')]
        
        @parameter_list.stubs(:options_without_signature).with().returns(:foo => 'bar')
        @parameter_list.stubs(:signature).with().returns('sig')
        
        @parameter_list.options_with_signature.should == {:foo => 'bar', :api_sig => 'sig'}
      end
      
      should "know the auth token when provided to the constructor" do
        pl = ParameterList.new(:auth_token => 'toke')
        pl.authentication_token.should == 'toke'
      end
      
      should "know the auth token when available as a global value" do
        Fleakr.stubs(:auth_token).with().returns('toke')
        
        pl = ParameterList.new
        pl.authentication_token.should == 'toke'
      end
      
      should "know that there is no authentication token if it is not available as a param or global value" do
        Fleakr.stubs(:auth_token).with().returns(nil)
        
        pl = ParameterList.new
        pl.authentication_token.should be_nil
      end

      should "be able to generate a boundary for post data" do
        rand = '0.123'
        
        @parameter_list.stubs(:rand).with().returns(stub(:to_s => rand))
        @parameter_list.boundary.should == Digest::MD5.hexdigest(rand)
      end

      should "be able to generate a list of parameters without a signature" do
        parameter = stub()
        
        @parameter_list.stubs(:sign?).with().returns(false)
        @parameter_list.expects(:options_without_signature).with().returns(:foo => 'bar')

        ValueParameter.expects(:new).with(:foo, 'bar').returns(parameter)
        
        @parameter_list.list.should == [parameter]
      end
      
      should "be able to generate a list of parameters with a signature" do
        parameter = stub()
        
        @parameter_list.stubs(:sign?).with().returns(true)
        @parameter_list.expects(:options_with_signature).with().returns(:foo => 'bar')

        ValueParameter.expects(:new).with(:foo, 'bar').returns(parameter)
        
        @parameter_list.list.should == [parameter]
      end
      
      should "be able to generate a list of parameters with upload parameters if available" do
        value_parameter = stub()
        file_parameter  = stub()
        
        @parameter_list.stubs(:sign?).with().returns(true)
        @parameter_list.expects(:options_with_signature).with().returns(:foo => 'bar')
        @parameter_list.expects(:upload_options).with().returns(:file => 'path')
        
        ValueParameter.expects(:new).with(:foo, 'bar').returns(value_parameter)
        FileParameter.expects(:new).with(:file, 'path').returns(file_parameter)
        
        @parameter_list.list.should == [value_parameter, file_parameter]
      end
            
      context "with associated parameters" do

        setup do
          @p1 = ValueParameter.new('a', 'b')
          @p2 = ValueParameter.new('c', 'd')

          @p1.stubs(:to_query).with().returns('q1')
          @p1.stubs(:to_form).with().returns('f1')

          @p2.stubs(:to_query).with().returns('q2')
          @p2.stubs(:to_form).with().returns('f2')

          @parameter_list.stubs(:list).with().returns([@p1, @p2])
        end

        should "be able to generate a query representation of itself" do
          @parameter_list.to_query.should == 'q1&q2'
        end

        should "be able to represent a form representation of itself" do
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