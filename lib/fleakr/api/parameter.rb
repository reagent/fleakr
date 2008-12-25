module Fleakr
  module Api
    
    class Parameter
      
      attr_reader :name, :value
      
      def initialize(name, value, include_in_signature = true)
        @name                 = name
        @value                = value
        @include_in_signature = include_in_signature
      end
      
      def include_in_signature?
        (@include_in_signature == true) ? true : false
      end
      
      def to_query
        "#{self.name}=#{CGI.escape(self.value)}"
      end
      
      def to_form
        "Content-Disposition: form-data; name=\"#{self.name}\"\r\n" +
        "\r\n" +
        "#{self.value}\r\n"
      end
      
      def <=>(other)
        self.name <=> other.name
      end
      
    end
    
  end
end