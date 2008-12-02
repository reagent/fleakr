module Fleakr
  class Error
    
    include Fleakr::Object
    
    flickr_attribute :code, :xpath => 'rsp/err', :attribute => 'code'
    flickr_attribute :message, :xpath => 'rsp/err', :attribute => 'msg'
    
  end
end