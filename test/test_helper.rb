$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'matchy'
require 'context'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/fleakr'