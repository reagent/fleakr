module Fleakr
  class Error
    
    include Fleakr::Object
    
    flickr_attribute :code, :from => 'rsp/err', :attribute => 'code'
    flickr_attribute :message, :from => 'rsp/err', :attribute => 'msg'
    
  end
end