$:.unshift(File.dirname(__FILE__))

require 'uri'
require 'cgi'
require 'net/http'
require 'hpricot'
require 'activesupport'

%w(support api objects).each do |path|
  full_path = File.expand_path(File.dirname(__FILE__)) + "/fleakr/#{path}"
  Dir["#{full_path}/*.rb"].each {|f| require f }
end