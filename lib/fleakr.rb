$:.unshift(File.dirname(__FILE__))

require 'uri'
require 'cgi'
require 'net/http'
require 'hpricot'

require 'fleakr/object'
require 'fleakr/attribute'
require 'fleakr/photo'
require 'fleakr/request'
require 'fleakr/response'
require 'fleakr/error'
require 'fleakr/set'
require 'fleakr/user'
require 'fleakr/group'
