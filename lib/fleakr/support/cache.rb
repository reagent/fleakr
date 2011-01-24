module Fleakr
  module Support
    class Cache

      def initialize
        @store  = {}
      end

      def key_for(options, identifier = nil)
        prefix = identifier.nil? ? '' : "#{identifier}_"
        prefix + sorted(options).join('_')
      end

      def for(options, identifier = nil, &block)
        key = key_for(options, identifier)
        @store[key] = block.call if !@store.has_key?(key)

        @store[key]
      end

      private

      def object?
        !object.nil?
      end

      def sorted(options)
        options.sort {|a, b| a[0].to_s <=> b[0].to_s }
      end

    end
  end
end