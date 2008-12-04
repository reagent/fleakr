module Fleakr
  module Object
    
    module ClassMethods
      
      def attributes
        @attributes ||= []
      end
      
      def flickr_attribute(name, options = {})
        self.attributes << Attribute.new(name, options)
        class_eval "attr_reader :#{name}"
      end
      
      def has_many(*attributes)
        options = attributes.extract_options!
        class_name = self.name

        attributes.each do |attribute|
          target = attribute.to_s.classify
          finder_attribute = options[:using].nil? ? "#{class_name.demodulize.underscore}_id": options[:using]
          class_eval <<-CODE
            def #{attribute}
              @#{attribute} ||= #{target}.send("find_all_by_#{finder_attribute}".to_sym, self.id)
            end
          CODE
        end
      end
      
    end
    
    module InstanceMethods
      
      def initialize(document = nil)
        self.populate_from(document) unless document.nil?
      end
      
      def populate_from(document)
        self.class.attributes.each do |attribute|
          value = attribute.value_from(document)
          instance_variable_set("@#{attribute.name}".to_sym, value) unless value.nil?
        end
      end
      
    end

    def self.included(other)
      other.send(:extend, Fleakr::Object::ClassMethods)
      other.send(:include, Fleakr::Object::InstanceMethods)
    end    
  end
  
end