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

module Fleakr

  # Set the API key for all requests. Example:
  #
  #  Fleakr.api_key = 'ABC123'
  #
  mattr_accessor :api_key

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
  
end
