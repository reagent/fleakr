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

  mattr_accessor :api_key

  def self.user(user_data)
    begin
      Objects::User.find_by_username(user_data)
    rescue Api::Request::ApiError
      Objects::User.find_by_email(user_data)
    end
  end
  
end
