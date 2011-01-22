module Fleakr
  module Support
    class Cache

      attr_reader :object

      def initialize(object = nil)
        @object = object
        @store  = {}
      end

      def key_for(options)
        key_prefix + sorted(options).join('_')
      end

      def for(options, &block)
        @store[key_for(options)] ||= block.call
      end

      private

      def key_prefix
        prefix = ''
        if object?
          prefix  = object.class.to_s.downcase.gsub('::', '_')
          prefix += "_#{object.id}_"
        end
        prefix
      end

      def object?
        !object.nil?
      end

      def sorted(options)
        options.sort {|a, b| a[0].to_s <=> b[0].to_s }
      end

    end
  end
end