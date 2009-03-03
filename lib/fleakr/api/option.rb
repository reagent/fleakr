module Fleakr
  module Api

    class Option
      
      MAPPING = {
        :tags        => 'TagOption',
        :viewable_by => 'ViewOption',
        :level       => 'LevelOption',
        :type        => 'TypeOption',
        :hide?       => 'HiddenOption'
      }
      
      def self.for(type, value)
        class_for(type).new(type, value)
      end
      
      def self.class_for(type)
        class_name = MAPPING[type] || 'SimpleOption'
        "Fleakr::Api::#{class_name}".constantize
      end
      
    end
    
    class SimpleOption

      attr_reader :type, :value
      
      def initialize(type, value)
        @type  = type
        @value = value
      end
      
      def to_hash
        {type => value}
      end
      
    end
    
    class TagOption < SimpleOption
      
      def initialize(type, value)
        super type, value
        @value = Array(self.value)
      end
    
      # TODO: handle tags with spaces?
      def to_hash
        {type => value.join(' ')}
      end
      
    end
    
    class ViewOption < SimpleOption
      
      def public?
        value == :everyone
      end
      
      def friends?
        value == :friends
      end
      
      def family?
        value == :family
      end
      
      def to_hash
        {:is_public => public?.to_i, :is_friend => friends?.to_i, :is_family => family?.to_i}
      end
      
    end
    
    class LevelOption < SimpleOption
      
      def value
        case @value
          when :safe: 1
          when :moderate: 2
          when :restricted: 3
        end
      end
      
      def to_hash
        {:safety_level => value}
      end
      
    end
    
    class TypeOption < SimpleOption
      
      def value
        case @value
          when :photo: 1
          when :screenshot: 2
          when :other: 3
        end
      end
      
      def to_hash
        {:content_type => value}
      end
      
    end
    
    class HiddenOption < SimpleOption
      
      def to_hash
        {:hidden => (value ? 2 : 1)}
      end
      
    end

  end
end