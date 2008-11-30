module Fleakr
  module Object
    
    module ClassMethods
      def flickr_attribute(name, options = {})
        class_eval <<-CODE
          def #{name}
            if @#{name}.nil?
              node = @response.at('#{options[:from]}')
              @#{name} = #{options[:attribute].nil?} ? node.inner_text : node['#{options[:attribute]}']
            end
            @#{name}
          end
        CODE
      end
    end
    
    module InstanceMethods
      def initialize(response)
        @response = response
      end
    end

    def self.included(other)
      other.send(:extend, Fleakr::Object::ClassMethods)
      other.send(:include, Fleakr::Object::InstanceMethods)
    end    
  end
  
end