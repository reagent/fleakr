$:.unshift(File.dirname(__FILE__))

require 'uri'
require 'cgi'
require 'net/http'
require 'rubygems'
require 'hpricot'
require 'activesupport'
require 'md5'

base_path = File.expand_path(File.dirname(__FILE__)) + "/fleakr"

require "#{base_path}/core_ext/uri/http"

require "#{base_path}/api/request"
require "#{base_path}/api/response"
require "#{base_path}/api/method_request"
require "#{base_path}/api/parameter"

%w(support objects).each do |path|
  Dir["#{base_path}/#{path}/*.rb"].each {|f| require f }
end

# = Fleakr: A teeny tiny gem to interface with Flickr
#
# Getting started is easy, just make sure you have a valid API key from Flickr and you can
# then start making any non-authenticated request to pull back data for yours and others' 
# photostreams, sets, contacts, groups, etc...
#
# For now, all activity originates from a single user which you can find by username or
# email address.
#
# Example:
#
#  require 'rubygems'
#  require 'fleakr'
#
#  # Our API key is ABC123 (http://www.flickr.com/services/api/keys/apply/)
#  Fleakr.api_key = 'ABC123'
#  user = Fleakr.user('bees')
#  user = Fleakr.user('user@host.com')
#  # Grab a list of sets
#  user.sets
#  # Grab a list of the user's public groups
#  user.groups
#
# To see what other associations and attributes are available, see the Fleakr::Objects::User class
#
module Fleakr

  mattr_accessor :api_key, :shared_secret, :mini_token, :auth_token

  # Find a user based on some unique user data.  This method will try to find
  # the user based on username and will fall back to email if that fails.  Example:
  #
  #  Fleakr.api_key = 'ABC123'
  #  Fleakr.user('the decapitator') # => #<Fleakr::Objects::User:0x692648 @username="the decapitator", @id="21775151@N06">
  #  Fleakr.user('user@host.com')   # => #<Fleakr::Objects::User:0x11f484c @username="bckspcr", @id="84481630@N00">
  #
  def self.user(user_data)
    begin
      Objects::User.find_by_username(user_data)
    rescue Api::Request::ApiError
      Objects::User.find_by_email(user_data)
    end
  end
  
  # Search all photos on the Flickr site.  By default, this searches based on text, but you can pass
  # different search parameters (passed as hash keys):
  #
  # [tags] The list of tags to search on (either as an array or comma-separated)
  # [user_id] Scope the search to this user
  # [group_id] Scope the search to this group
  #
  # If you're interested in User- and Group-scoped searches, you may want to use User#search and Group#search
  # instead.
  #
  def self.search(params)
    params = {:text => params} unless params.is_a?(Hash)
    Objects::Search.new(params).results
  end
  
end
