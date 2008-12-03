$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'matchy'
require 'context'
require 'mocha'
require 'activesupport'

require File.dirname(__FILE__) + '/../lib/fleakr'

class Test::Unit::TestCase

  def self.should_have_a_value_for(attribute_test)
    it "should have a value for :#{attribute_test.keys.first}" do
      @object.send(attribute_test.keys.first).should == attribute_test.values.first
    end
  end

  def self.should_find_one(thing, options)
    class_name  = thing.to_s.singularize.camelcase
    klass       = "Fleakr::#{class_name}".constantize
    object_type = class_name.downcase    

    options[:with] = options[:by] if options[:with].nil?

    it "should be able to find a #{thing} by #{options[:by]}" do
      condition_value = '1'
      stub = stub()
      response = mock_request_cycle :for => options[:call], :with => {options[:with] => condition_value}

      klass.expects(:new).with(response.body).returns(stub)
      klass.send("find_by_#{options[:by]}".to_sym, condition_value).should == stub
    end
  end

  def self.should_find_all(thing, options)
    class_name  = thing.to_s.singularize.camelcase
    klass       = "Fleakr::#{class_name}".constantize
    object_type = class_name.downcase
    
    it "should be able to find all #{thing} by #{options[:by]}" do
      condition_value = '1'
      response = mock_request_cycle :for => options[:call], :with => {options[:by] => condition_value}
      
      stubs = []
      elements = (response.body/options[:path]).map
      
      
      elements.each do |element|
        stub = stub()
        stubs << stub
        
        klass.expects(:new).with(element).returns(stub)
      end
      
      klass.send("find_all_by_#{options[:by]}".to_sym, condition_value).should == stubs
    end
    
  end
  
  def read_fixture(method_call)
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    File.read("#{fixture_path}/#{method_call}.xml")
  end
  
  def mock_request_cycle(options)
    response = stub(:body => Hpricot.XML(read_fixture(options[:for])))
    Fleakr::Request.expects(:with_response!).with(options[:for], options[:with]).returns(response)
    
    response
  end
  
  def create_temp_directory
    tmp_dir = File.dirname(__FILE__) + '/tmp'
    FileUtils.mkdir(tmp_dir)  
    
    tmp_dir
  end
  
end