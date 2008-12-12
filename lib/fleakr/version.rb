module Fleakr
  module Version # :nodoc:
    
    MAJOR = 0
    MINOR = 3
    TINY  = 0
    
    def self.to_s
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end