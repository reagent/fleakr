module Fleakr
  module Support
    class Association

      include Utility

      attr_reader :source, :name, :target_name

      def initialize(source, name, target_name = nil)
        @source      = source
        @target_name = target_name
        @name        = name
      end

      def target
        target_name? ? target_name : name
      end

      def target_class
        Fleakr::Objects.const_get(class_name(target))
      end

      def scope_attribute
        id_attribute_for(source.class.name)
      end

      def finder_method
        method_name  = "find_all_"
        method_name += "#{name}_" if target_name?
        method_name += "by_#{scope_attribute}"

        method_name.to_sym
      end

      def results(options = {})
        cache.for(options) { target_class.send(finder_method, source.id, options) }
      end

      private

      def cache
        @cache ||= Cache.new
      end

      def target_name?
        !blank?(target_name)
      end

    end
  end
end