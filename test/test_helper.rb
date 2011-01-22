$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/fleakr'

class Test::Unit::TestCase

  def self.should_autoload_when_accessing(*attributes)
    attributes, options = Fleakr::Support::Utility.extract_options(attributes)

    attributes.each do |accessor_name|
      should "load the additional user information when accessing the :#{accessor_name} attribute" do
        class_name = self.class.name.match(/([^:]+)Test$/)[1]
        klass      = Fleakr::Objects.const_get(class_name)

        object = klass.new
        object.expects(options[:with]).with()
        object.send(accessor_name)
      end
    end
  end

  def self.should_have_a_value_for(attribute_test)
    should "have a value for :#{attribute_test.keys.first}" do
      @object.send(attribute_test.keys.first).should == attribute_test.values.first
    end
  end

  def self.should_search_by(key)
    should "be able to perform a scoped search by :#{key}" do
      photos = [stub()]
      search = stub(:results => photos)

      class_name = self.class.name.match(/([^:]+)Test$/)[1]
      klass      = Fleakr::Objects.const_get(class_name)

      instance = klass.new
      instance.stubs(:id).with().returns('1')

      Fleakr::Objects::Search.expects(:new).with('foo', key => '1').returns(search)

      instance.search('foo').should == photos
    end
  end

  def self.should_have_many(*attributes)
    attributes, options = Fleakr::Support::Utility.extract_options(attributes)

    class_name = self.name.to_s.match(/([^:]+)Test$/)[1]
    klass      = Fleakr::Objects.const_get(class_name)

    association_class = options[:class]

    finder_attribute = options[:using].nil? ? Fleakr::Support::Utility.id_attribute_for(class_name) : options[:using]

    method = options[:method] || "find_all_by_#{finder_attribute}"

    attributes.each do |attribute|

      should "be able to retrieve the #{class_name.downcase}'s #{attribute}" do
        results = [stub()]
        object = klass.new
        object.stubs(:id).with().returns('1')

        association_class.expects(method.to_sym).with('1', {}).returns(results)
        object.send(attribute).should == results
      end

      should "memoize the results for the #{class_name.downcase}'s #{attribute}" do
        object = klass.new

        association_class.expects(method.to_sym).once.returns([])
        2.times { object.send(attribute) }
      end

    end
  end

  def self.should_find_one(thing, options)
    condition_value = '1'

    options[:with] = options[:by] if options[:with].nil?
    params = {options[:with] => condition_value}

    should "be able to find a #{thing} by #{options[:by]}" do
      stub = stub()
      response = mock_request_cycle :for => options[:call], :with => params

      options[:class].expects(:new).with(response.body, params).returns(stub)
      options[:class].send("find_by_#{options[:by]}".to_sym, condition_value).should == stub
    end
  end

  def self.should_find_all(thing, options)
    should "be able to find all #{thing} by #{options[:by]}" do
      condition_value = '1'
      finder_options = {(options[:using] || options[:by]) => condition_value}

      response = mock_request_cycle :for => options[:call], :with => finder_options

      stubs = []
      elements = (response.body/options[:path]).map

      elements.each do |element|
        stub = stub()
        stubs << stub

        options[:class].expects(:new).with(element, finder_options).returns(stub)
      end

      method = options[:method] || "find_all_by_#{options[:by]}"

      options[:class].send(method.to_sym, condition_value).should == stubs
    end

  end

  def read_fixture(method_call)
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    File.read("#{fixture_path}/#{method_call}.xml")
  end

  def mock_request_cycle(options)
    response = stub(:body => Hpricot.XML(read_fixture(options[:for])))
    Fleakr::Api::MethodRequest.expects(:with_response!).with(options[:for], options[:with]).returns(response)

    response
  end

  def create_temp_directory
    tmp_dir = File.dirname(__FILE__) + '/tmp'
    FileUtils.mkdir(tmp_dir)

    tmp_dir
  end

end