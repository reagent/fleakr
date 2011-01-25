$:.unshift(File.dirname(__FILE__))

require 'uri'
require 'cgi'
require 'net/http'
require 'time'
require 'hpricot'
require 'forwardable'

require 'digest/md5'
require 'fileutils'
require 'loggable'

require 'fleakr/support'
require 'fleakr/api'
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

  class << self
    attr_accessor :api_key, :shared_secret, :auth_token
  end

  # Find a user based on some unique user data.  This method will try to find
  # the user based on several methods, starting with username and falling back to email and URL
  # sequentially if these methods fail. Example:
  #
  #  Fleakr.api_key = 'ABC123'
  #  Fleakr.user('the decapitator')
  #  Fleakr.user('user@host.com')
  #  Fleakr.user('http://www.flickr.com/photos/the_decapitator/')
  #

  # TODO: Use User.find_by_identifier for some of this
  def self.user(user_data, options = {})
    user = nil
    [:username, :email, :url].each do |attribute|
      if user.nil?
        user = Objects::User.send("find_by_#{attribute}", user_data, options) rescue nil
      end
    end
    user
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
  # Additionally, options can be supplied as part of the upload that will apply to all files
  # that are matched by the pattern passed to <tt>glob</tt>.  For a full list, see
  # Fleakr::Objects::Photo.
  #
  def self.upload(glob, options = {})
    Dir[glob].map {|file| Fleakr::Objects::Photo.upload(file, options) }
  end

  # Get all contacts for the currently authenticated user.  The provided contact type can be
  # one of the following:
  #
  # [:friends] Only contacts who are friends (and not family)
  # [:family] Only contacts who are family (and not friends)
  # [:both] Only contacts who are both friends and family
  # [:neither] Only contacts who are neither friends nor family
  #
  # Additional parameters supported are:
  #
  # [:page] The page of results to return
  # [:per_page] The number of contacts to retrieve per page
  #
  def self.contacts(contact_type = nil, additional_options = {})
    options = {}
    options.merge!(:filter => contact_type) unless contact_type.nil?
    options.merge!(additional_options)

    Fleakr::Objects::Contact.find_all(options)
  end

  # Generate an authorization URL to redirect users to.  This defaults to
  # 'read' permission, but others are available when passed to this method:
  #
  #  * :read - permission to read private information (default)
  #  * :write - permission to add, edit and delete photo metadata (includes 'read')
  #  * :delete - permission to delete photos (includes 'write' and 'read')
  #
  def self.authorization_url(permissions = :read)
    request = Fleakr::Api::AuthenticationRequest.new(:perms => permissions)
    request.authorization_url
  end

  # Exchange a frob for an authentication token.  See Fleakr.authorization_url for
  # more information.
  #
  def self.token_from_frob(frob)
    Fleakr::Objects::AuthenticationToken.from_frob(frob)
  end

  # Exchange a mini token for an authentication token.
  #
  def self.token_from_mini_token(mini_token)
    Fleakr::Objects::AuthenticationToken.from_mini_token(mini_token)
  end

  # Get the user that this authentication token belongs to.  Useful for pulling
  # relationships scoped to this user.
  #
  def self.user_for_token(auth_token)
    token = Fleakr::Objects::AuthenticationToken.from_auth_token(auth_token)
    token.user
  end

  # Retrieve a photo, person, or set from a flickr.com URL:
  #
  def self.resource_from_url(url)
    Fleakr::Objects::Url.new(url).resource
  end

end

# Alias Fleakr methods as Flickr if possible
if defined?(Flickr).nil?
  Flickr = Fleakr
end