module Fleakr
  module Api # :nodoc:

    # = Option
    #
    # Top-level class for creating specific option instances based on type
    #
    class Option
      
      MAPPING = {
        :tags        => 'TagOption',
        :viewable_by => 'ViewOption',
        :level       => 'LevelOption',
        :type        => 'TypeOption',
        :hide?       => 'HiddenOption'
      }
      
      # Initialize a new option for the specified type and value
      #
      def self.for(type, value)
        class_for(type).new(type, value)
      end
      
      def self.class_for(type) # :nodoc:
        class_name = MAPPING[type] || 'SimpleOption'
        "Fleakr::Api::#{class_name}".constantize
      end
      
    end
    
    # = SimpleOption
    # 
    # Simple name / value option pair
    #
    class SimpleOption

      attr_reader :type, :value
     
      # Create an option of the specified type and value
      #
      def initialize(type, value)
        @type  = type
        @value = value
      end
      
      # Generate hash representation of this option
      #
      def to_hash
        {type => value}
      end
      
    end
    
    # = TagOption
    #
    # Represents values for tags
    #
    class TagOption < SimpleOption
      
      # Tag with specified values.  Value passed will be converted to an array if it isn't
      # already
      # 
      def initialize(type, value)
        super type, value
        @value = Array(self.value)
      end
    
      # Hash representation of tag values (separated by spaces).  Handles multi-word tags 
      # by enclosing each tag in double quotes.
      #
      def to_hash
        tags = value.map {|tag| "\"#{tag}\"" }
        {type => tags.join(' ')}
      end
      
    end
    
    # = ViewOption
    #
    # Specify who is able to view the photo.
    #
    class ViewOption < SimpleOption
      
      # Specify who this is viewable by (e.g. everyone / friends / family).
      #
      def initialize(type, value)
        super type, Array(value)
      end
      
      # Is this publicly viewable? (i.e. :everyone)
      #
      def public?
        value == [:everyone]
      end
      
      # Is this viewable by friends? (i.e. :friends)
      #
      def friends?
        value.include?(:friends)
      end

      # Is this viewable by family? (i.e. :family)
      #
      def family?
        value.include?(:family)
      end
      
      # Hash representation of photo permissions
      #
      def to_hash
        {:is_public => public?.to_i, :is_friend => friends?.to_i, :is_family => family?.to_i}
      end
      
    end
    
    # = LevelOption
    #
    # Specify the "safety level" of this photo (e.g. safe / moderate / restricted)
    #
    class LevelOption < SimpleOption
     
      def value # :nodoc: 
        case @value
          when :safe        then 1
          when :moderate    then 2
          when :restricted  then 3
        end
      end
      
      # Hash representation of the safety_level for this photo
      #
      def to_hash
        {:safety_level => value}
      end
      
    end
    
    # = TypeOption
    #
    # Specify the type of this photo (e.g. photo / screenshot / other)
    #
    class TypeOption < SimpleOption
      
      def value # :nodoc:
        case @value
          when :photo       then 1
          when :screenshot  then 2
          when :other       then 3
        end
      end
      
      # Hash representation of this type
      #
      def to_hash
        {:content_type => value}
      end
      
    end
    
    # = HiddenOption
    #
    # Specify whether this photo should be hidden from search
    #
    class HiddenOption < SimpleOption
     
      # Hash representation of whether to hide this photo
      #
      def to_hash
        {:hidden => (value ? 2 : 1)}
      end
      
    end

  end
end