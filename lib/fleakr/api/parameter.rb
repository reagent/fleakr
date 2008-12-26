module Fleakr
  module Api
    
    class Parameter
      
      attr_reader :name
      
      def initialize(name, include_in_signature = true)
        @name                 = name
        @include_in_signature = include_in_signature
      end
      
      def include_in_signature?
        (@include_in_signature == true) ? true : false
      end
      
      def <=>(other)
        self.name <=> other.name
      end
      
    end
    
  end
end