module Fleakr
  module Version # :nodoc:
    
    MAJOR = 0
    MINOR = 6
    TINY  = 3
    
    def self.to_s
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end