module Fleakr
  class Attribute
    
    attr_reader :name
    
    def initialize(name, options = {})
      @name = name
      @options = {:xpath => @name}.merge(options)
    end
    
    def xpath
      @options[:xpath]
    end
    
    def attribute
      @options[:attribute]
    end
    
  end
end
