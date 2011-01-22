module Fleakr
  module Support # :nodoc:

    # = Utility
    #
    # Helpful utility methods.
    #
    module Utility

      extend self

      # Given a module name and an underscored name, generate the fully
      # namespaced class name.  For example:
      #
      #   >> Utility.class_name_for('Fleakr::Api', 'method_request')
      #   => "Fleakr::Api::MethodRequest"
      #
      def class_name_for(module_name, name)
        "#{module_name}::#{class_name(name)}"
      end

      def class_name(name)
        class_name = name.to_s.sub(/^(\w)/) {|m| m.upcase }
        class_name = class_name.sub(/(_(\w))/) {|m| $2.upcase }
        class_name = class_name.sub(/s$/, '')
      end

      # Given a class name as a string with an optional namespace, generate
      # an attribute ID parameter suitable for retrieving the ID of an associated
      # object.  For example:
      #
      #   >> Utility.id_attribute_for('Fleakr::Objects::Set')
      #   => "set_id"
      #
      def id_attribute_for(class_name)
        class_name = class_name.match(/([^:]+)$/)[1]
        class_name.gsub!(/([A-Z])([A-Z][a-z])/, '\1_\2')
        class_name.gsub!(/([a-z])([A-Z])/, '\1_\2')

        "#{class_name.downcase}_id"
      end

      # Determine if the passed value is blank.  Blank values include nil,
      # the empty string, and a string with only whitespace.
      #
      def blank?(object)
        object.to_s.sub(/\s+/, '') == ''
      end

      # Extract the options from an array if present and return the new array
      # and any available options.  For example:
      #
      #   >> Utility.extract_options([:sets, {:using => :key}])
      #   => [[:sets], {:using => :key}]
      #
      # Note that this method does not modify the supplied parameter.
      #
      def extract_options(array_with_possible_options)
        array = array_with_possible_options.dup

        options = array.pop if array.last.is_a?(Hash)
        options ||= {}

        [array, options]
      end

    end

  end
end