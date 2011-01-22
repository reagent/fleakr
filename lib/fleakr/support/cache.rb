module Fleakr
  module Support
    class Cache

      def initialize
        @store = {}
      end

      def key_for(options)
        sorted(options).join('_')
      end

      def for(options, &block)
        @store[key_for(options)] ||= block.call
      end

      private

      def sorted(options)
        options.sort {|a, b| a[0].to_s <=> b[0].to_s }
      end

    end
  end
end