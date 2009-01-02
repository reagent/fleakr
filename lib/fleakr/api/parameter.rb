module Fleakr
  module Api # :nodoc:

    # = Parameter
    # 
    # Base class for other parameters that get passed to the Flickr API - see
    # #FileParameter and #ValueParameter for examples
    #
    class Parameter
     
      attr_reader :name
     
      # A new named parameter (never used directly)
      #
      def initialize(name, include_in_signature = true)
        @name                 = name
        @include_in_signature = include_in_signature
      end
      
      # Should this parameter be used when generating the signature?
      #
      def include_in_signature?
        (@include_in_signature == true) ? true : false
      end
      
      # Used for sorting when generating a signature
      #
      def <=>(other)
        self.name <=> other.name
      end
      
    end
    
  end
end