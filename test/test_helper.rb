$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'matchy'
require 'context'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/fleakr'

class Test::Unit::TestCase
  
  def read_fixture(method_call)
    fixture_path = File.dirname(__FILE__) + '/fixtures'
    File.read("#{fixture_path}/#{method_call}.xml")
  end
  
  def mock_request_cycle(options)
    response = stub(:body => Hpricot.XML(read_fixture(options[:for])))
    Fleakr::Request.expects(:with_response!).with(options[:for], options[:with]).returns(response)
  end
  
end