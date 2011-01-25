module Fleakr
  module Support # :nodoc:all
    module Object

      module ClassMethods

        def attributes
          @attributes ||= []
        end

        def flickr_attribute(*names_and_options)
          attributes, options = Utility.extract_options(names_and_options)

          attributes.each do |name|
            self.attributes << Attribute.new(name, options[:from])
            class_eval "attr_accessor :#{name}"
          end
        end

        def has_many(*attributes)
          attributes.each {|a| association(a) }
        end

        def association(name, options = {})
          class_eval <<-CODE
            def #{name}(options = {})
              @#{name} ||= Association.new(self, "#{name}", "#{options[:type]}")

              options = authentication_options.merge(options)
              @#{name}.results(options)
            end
          CODE
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
          key = Utility.id_attribute_for(self.name)

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
          attributes, options = Utility.extract_options(attributes)

          attributes.each do |attribute|
            class_eval <<-CODE
              alias_method :#{attribute}_without_loading, :#{attribute}
              def #{attribute}
                self.send(:#{options[:with]}) if @#{attribute}.nil?
                #{attribute}_without_loading
              end
            CODE
          end
        end

      end

      module InstanceMethods

        attr_reader :document, :authentication_options

        def initialize(document = nil, options = {})
          populate_from(document) unless document.nil?
          @authentication_options = extract_authentication_from(options)
        end

        def populate_from(document)
          @document = document
          self.class.attributes.each do |attribute|
            value = attribute.value_from(document)
            send("#{attribute.name}=".to_sym, value) unless value.nil?
          end
          self
        end

        def with_caching(options, identifier, &block)
          cache.for(options, identifier, &block)
        end

        def cache
          @cache ||= Fleakr::Support::Cache.new
        end

        def inspect
          names      = instance_variables.reject {|n| %w(@associations @document).include?(n.to_s) }
          attributes = names.map {|n| "#{n}=#{instance_variable_get(n).inspect}" }

          "#<#{self.class} #{attributes.join(', ')}>"
        end

        private

        def extract_authentication_from(options)
          options.has_key?(:auth_token) ? {:auth_token => options[:auth_token]} : {}
        end
      end

      def self.included(other)
        other.send(:extend, Fleakr::Support::Object::ClassMethods)
        other.send(:include, Fleakr::Support::Object::InstanceMethods)
      end

    end
  end
end