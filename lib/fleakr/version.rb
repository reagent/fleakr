module Fleakr
  module Version
    
    MAJOR = 0
    MINOR = 2
    TINY  = 1
    
    def self.to_s
      [MAJOR, MINOR, TINY].join('.')
    end
    
  end
end