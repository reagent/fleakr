$:.unshift(File.dirname(__FILE__))
require 'rubygems'

require 'uri'
require 'cgi'
require 'net/http'
require 'hpricot'
require 'activesupport'
require 'md5'
require 'loggable'

require 'fleakr/api'
require 'fleakr/core_ext'
require 'fleakr/support'
require 'fleakr/objects'

# = Fleakr: A small, yet powerful, gem to interface with Flickr photostreams
#
# == Quick Start
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
# == Authentication
#
# If you want to do something more than just retrieve public photos (like upload your own), 
# you'll need to generate an authentication token to use across requests and sessions.
#
# Assuming you've already applied for a key, go back and make sure you have the right settings
# to get your auth token.  Click on the 'Edit key details' link and ensure that:
#
# 1. Your application description and notes are up-to-date
# 1. The value for 'Authentication Type' is set to 'Mobile Application'
# 1. The value for 'Mobile Permissions' is set to either 'write' or 'delete'
#
# Once this is set, you'll see your Authentication URL on the key details page (it will look
# something like http://www.flickr.com/auth-534525246245).  Paste this URL into your browser and 
# confirm access to get your mini-token. Now you're ready to make authenticated requests:
#
#   require 'rubygems'
#   require 'fleakr'
#
#   Fleakr.api_key       = 'ABC123'
#   Fleakr.shared_secret = 'sekrit' # Available with your key details on the Flickr site
#   Fleakr.mini_token    = '362-133-214'
#
#   Fleakr.upload('/path/to/my/photo.jpg')
#   Fleakr.token.value # => "34132412341235-12341234ef34"
# 
# Once you use the mini-token once, it is no longer available.  To use the generated auth_token
# for future requests, just set Fleakr.auth_token to the generated value.
#
module Fleakr

  # Generic catch-all exception for any API errors
  class ApiError < StandardError; end

  mattr_accessor :api_key, :shared_secret, :mini_token, :auth_token, :frob

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
    rescue ApiError
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
  
  # Upload one or more files to your Flickr account (requires authentication).  Simply provide
  # a filename or a pattern to upload one or more files:
  #
  #  Fleakr.upload('/path/to/my/mug.jpg')
  #  Fleakr.upload('/User/Pictures/Party/*.jpg')
  #
  def self.upload(glob)
    Dir[glob].each {|file| Fleakr::Objects::Photo.upload(file) }
  end

  # Get the authentication token needed for authenticated requests.  Will either use
  # a valid auth_token (if available) or a mini-token to generate the auth_token.
  #
  def self.token
    @token ||= begin
      if Fleakr.auth_token
        Fleakr::Objects::AuthenticationToken.from_auth_token(Fleakr.auth_token)
      elsif Fleakr.frob
        Fleakr::Objects::AuthenticationToken.from_frob(Fleakr.frob)
      elsif Fleakr.mini_token
        Fleakr::Objects::AuthenticationToken.from_mini_token(Fleakr.mini_token)
      end
    end
  end
  
  # Reset the cached token whenever setting a new value for the mini_token, auth_token, or frob
  #
  [:mini_token, :auth_token, :frob].each do |attribute|
    class_eval <<-ACCESSOR
      def self.#{attribute}=(#{attribute})
        reset_token
        @@#{attribute} = #{attribute}
      end
    ACCESSOR
  end

  def self.reset_token # :nodoc: #
    @token = nil
  end
  
end
