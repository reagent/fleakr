module Fleakr

  module Support

    # Extention to Array allowing custom attributes to be set and retrieved
    module ResultArray
   
      # Set the attributes on the result array
      def attributes=( attributes )
        attributes = ResultArray.sanitize_hpricot_attributes( attributes )
        @attributes = attributes
      end

      # Try to lookup the method name in the attributes list
      def method_missing( name, *args )
        return @attributes[ name ] if ( !@attributes.nil? && @attributes.key?( name ) )
        raise NoMethodError
      end

      private

      # Converts an HPricot attributes hash to a normal ruby Hash.
      # 
      # The keys of the attributes are transformed to symbols.  Values
      # that appear to be integers are converted to integers.
      def self.sanitize_hpricot_attributes( attributes )
        pairs = attributes.to_hash.map do |key,value|
          value = value.to_i if value =~ /\A[0-9]+\z/
          [ key.to_sym, value ]
        end
        Hash[ pairs ]
      end

    end
  end
end
