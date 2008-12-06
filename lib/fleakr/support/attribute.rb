module Fleakr
  module Support
    class Attribute

      attr_reader :name, :xpath, :attribute

      def initialize(name, options = {})
        @name = name.to_sym
        @attribute = options[:attribute]

        @xpath = options[:xpath]
        @xpath ||= @name.to_s unless @attribute
      end

      def value_from(document)
        node = document

        begin 
          node = document.at(self.xpath) if self.xpath
          self.attribute.nil? ? node.inner_text : node[self.attribute]
        rescue NoMethodError
          nil
        end
      end

    end
  end
end