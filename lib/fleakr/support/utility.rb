module Fleakr
  module Support

    class Utility

      def self.class_name_for(module_name, name)
        class_name = name.to_s.sub(/^(\w)/) {|m| m.upcase }
        class_name = class_name.sub(/(_(\w))/) {|m| $2.upcase }
        class_name = class_name.sub(/s$/, '')

        "#{module_name}::#{class_name}"
      end

      def self.id_attribute_for(class_name)
        class_name = class_name.match(/([^:]+)$/)[1]
        class_name.gsub!(/([A-Z])([A-Z][a-z])/, '\1_\2')
        class_name.gsub!(/([a-z])([A-Z])/, '\1_\2')

        "#{class_name.downcase}_id"
      end

      def self.blank?(object)
        object.to_s.sub(/\s+/, '') == ''
      end

      def self.extract_options(array_with_possible_options)
        array = array_with_possible_options.dup

        options = array.pop if array.last.is_a?(Hash)
        options ||= {}

        [array, options]
      end

    end

  end
end