$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'matchy'
require 'context'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/fleakr'

class Test::Unit::TestCase
  
  def read_fixture(method_call)
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    Hpricot.XML(File.read("#{fixture_path}/#{method_call}.xml"))
  end
  
  def mock_request_cycle(options)
    response = stub(:body => read_fixture(options[:for]))
    Fleakr::Request.expects(:new).with(options[:for], options[:with]).returns(stub(:send => response))
  end
  
end