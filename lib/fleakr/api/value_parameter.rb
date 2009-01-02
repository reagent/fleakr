module Fleakr
  module Api # :nodoc:
    
    # = ValueParameter
    #
    # A simple name / value parameter for use in API calls
    #
    class ValueParameter < Parameter
      
      attr_reader :value
     
      # Create a new parameter with the specified name / value pair.
      #
      def initialize(name, value, include_in_signature = true)
        @value = value
        super(name, include_in_signature)
      end
      
      # Generate the query string representation of this parameter.
      #
      def to_query
        "#{self.name}=#{CGI.escape(self.value.to_s)}"
      end
      
      # Generate the form representation of this parameter.
      #
      def to_form
        "Content-Disposition: form-data; name=\"#{self.name}\"\r\n" +
        "\r\n" +
        "#{self.value}\r\n"
      end
      
    end
    
  end
end