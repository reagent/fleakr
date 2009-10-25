require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
  class FileParameterTest < Test::Unit::TestCase
    
    context "An instance of the FileParameter class" do
      
      setup do
        @temp_dir = File.expand_path(create_temp_directory)
        @filename = "#{@temp_dir}/image.jpg"
      end
      
      teardown do
        FileUtils.rm_rf(@temp_dir)
      end
      
      {'jpg' => 'image/jpeg', 'png' => 'image/png', 'gif' => 'image/gif'}.each do |ext, mime_type|
        should "know the correct MIME type for an extension of #{ext}" do
          parameter = FileParameter.new('photo', "#{@temp_dir}/image.#{ext}")
          parameter.mime_type.should == mime_type
        end
      end
      
      should "retrieve the contents of the file when accessing the value" do
        File.expects(:read).with(@filename).returns('bopbip')
        
        parameter = FileParameter.new('photo', @filename)
        parameter.value.should == 'bopbip'
      end
      
      should "cache the file contents after retrieving them" do
        File.expects(:read).with(@filename).once.returns('bopbip')
        
        parameter = FileParameter.new('photo', @filename)
        2.times { parameter.value }
      end
      
      should "know how to generate a form representation of itself" do
        filename  = 'image.jpg'
        mime_type = 'image/jpeg'

        parameter = FileParameter.new('photo', filename)
        parameter.stubs(:mime_type).with().returns(mime_type)
        parameter.stubs(:value).with().returns('data')
        
        expected = 
          "Content-Disposition: form-data; name=\"photo\"; filename=\"#{filename}\"\r\n" +
          "Content-Type: image/jpeg\r\n" +
          "\r\n" +
          "data\r\n"
        
        parameter.to_form.should == expected
      end
      
    end
    
  end
end