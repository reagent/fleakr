module Fleakr
  module Support # :nodoc:all
    class Attribute

      # TODO: Refactor the location / attribute logic into a Source class

      attr_reader :name, :sources

      def initialize(name, sources = nil)
        @name = name.to_sym

        @sources = Array(sources)
        @sources << @name.to_s if @sources.empty?
      end

      def split(source)
        location, attribute = source.split('@')
        location = self.name.to_s if location.blank?

        [location, attribute]
      end

      def node_for(document, source)
        document.at(location(source)) || document.search("//[@#{attribute(source)}]").first
      end

      def attribute(source)
        location, attribute = source.split('@')
        attribute || location
      end

      def location(source)
        split(source).first
      end

      def value_from(document)
        values = sources.map do |source|
          node = node_for(document, source)
          [node.attributes[attribute(source)], node.inner_text].reject{|v| v.blank?}.first unless node.nil?
        end
        values.compact.first
      end

    end
  end
end