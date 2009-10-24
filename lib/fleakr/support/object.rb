module Fleakr
  module Support # :nodoc:all
    module Object
    
      module ClassMethods
      
        def attributes
          @attributes ||= []
        end
      
        def flickr_attribute(*names_and_options)
          options = names_and_options.extract_options!

          names_and_options.each do |name|
            self.attributes << Attribute.new(name, options[:from])
            class_eval "attr_accessor :#{name}"
          end
        end
      
        def has_many(*attributes)
          class_name = self.name

          attributes.each do |attribute|
            target           = "Fleakr::Objects::#{attribute.to_s.classify}"
            finder_attribute = "#{class_name.demodulize.underscore}_id"

            class_eval <<-CODE
              def #{attribute}
                @#{attribute} ||= #{target}.send("find_all_by_#{finder_attribute}".to_sym, self.id, self.authentication_options)
              end
            CODE
          end
        end
      
        def find_all(condition, options)
          attribute    = options[:using].nil? ? condition.to_s.sub(/^by_/, '') : options[:using]
          target_class = options[:class_name].nil? ? self.name : "Fleakr::Objects::#{options[:class_name]}"
        
          class_eval <<-CODE
            def self.find_all_#{condition}(value, options = {})
              options.merge!(:#{attribute} => value)
              
              response = Fleakr::Api::MethodRequest.with_response!('#{options[:call]}', options)
              (response.body/'rsp/#{options[:path]}').map {|e| #{target_class}.new(e, options) }
            end
          CODE
        end
      
        def find_one(condition, options)
          attribute = options[:using].nil? ? condition.to_s.sub(/^by_/, '') : options[:using]
        
          class_eval <<-CODE
            def self.find_#{condition}(value, options = {})
              options.merge!(:#{attribute} => value)
              
              response = Fleakr::Api::MethodRequest.with_response!('#{options[:call]}', options)
              #{self.name}.new(response.body, options)
            end
          CODE
        end
        
        def scoped_search
          key = "#{self.name.demodulize.underscore.downcase}_id".to_sym

          class_eval <<-CODE
            def search(*parameters)
              options = {:#{key} => self.id}
              options.merge!(self.authentication_options)
              
              parameters << options
              Fleakr::Objects::Search.new(*parameters).results
            end
          CODE
        end

        def lazily_load(*attributes)
          options = attributes.extract_options!

          attributes.each do |attribute|
            class_eval <<-CODE
              def #{attribute}_with_loading
                self.send(:#{options[:with]}) if @#{attribute}.nil?
                #{attribute}_without_loading
              end
              alias_method_chain :#{attribute}, :loading
            CODE
          end
        end
      
      end
    
      module InstanceMethods
      
        attr_reader :document, :authentication_options
      
        def initialize(document = nil, options = {})
          self.populate_from(document) unless document.nil?
          @authentication_options = options.extract!(:auth_token)
        end
      
        def populate_from(document)
          @document = document
          self.class.attributes.each do |attribute|
            value = attribute.value_from(document)
            self.send("#{attribute.name}=".to_sym, value) unless value.nil?
          end
        end
      
      end

      def self.included(other)
        other.send(:extend, Fleakr::Support::Object::ClassMethods)
        other.send(:include, Fleakr::Support::Object::InstanceMethods)
      end
      
    end
  end
end