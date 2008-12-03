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