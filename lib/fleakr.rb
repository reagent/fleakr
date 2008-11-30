$:.unshift(File.dirname(__FILE__))

require 'uri'
require 'cgi'
require 'net/http'
require 'hpricot'

Dir.glob(File.dirname(__FILE__) + '/**/*').each {|f| require f }
