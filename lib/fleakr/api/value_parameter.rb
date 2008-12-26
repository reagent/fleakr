module Fleakr
  module Api
    
    class ValueParameter < Parameter
      
      attr_reader :value
      
      def initialize(name, value, include_in_signature = true)
        @value = value
        super(name, include_in_signature)
      end
      
      def to_query
        "#{self.name}=#{CGI.escape(self.value)}"
      end
      
      def to_form
        "Content-Disposition: form-data; name=\"#{self.name}\"\r\n" +
        "\r\n" +
        "#{self.value}\r\n"
      end
      
    end
    
  end
end