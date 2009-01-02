module Fleakr
  module Api # :nodoc:
    
    # = ParameterList
    #
    # Represents a list of parameters that get passed as part of a
    # MethodRequest or UploadRequest.  These can be transformed as necessary
    # into query strings (using #to_query) or form data (using #to_form)
    #
    class ParameterList
      
      # Create a new parameter list with optional parameters:
      # [:sign?] Will these parameters be used to sign the request?
      # [:authenticate?] Will the request need to be authenticated?
      #
      # Any additional name / value pairs will be created as individual 
      # ValueParameters as part of the list.  Example:
      #
      #   >> list = Fleakr::Api::ParameterList.new(:foo => 'bar')
      #   => #<Fleakr::Api::ParameterList:0x1656e6c @list=... >
      #   >> list[:foo]
      #   => #<Fleakr::Api::ValueParameter:0x1656da4 @include_in_signature=true, @name="foo", @value="bar">
      #
      def initialize(options = {})
        @api_options = options.extract!(:sign?, :authenticate?)
        
        @list = Hash.new

        options.each {|k,v| self << ValueParameter.new(k.to_s, v) }

        self << ValueParameter.new('api_key', Fleakr.api_key)
        self << ValueParameter.new('auth_token', Fleakr.token.value) if authenticate?
      end
      
      # Add a new parameter (ValueParameter / FileParameter) to the list
      #
      def <<(parameter)
        @list.merge!(parameter.name => parameter)
      end
      
      # Should this parameter list be signed?
      #
      def sign?
        (@api_options[:sign?] == true || authenticate?) ? true : false
      end
      
      # Should we send the auth_token with the request?
      #
      def authenticate?
        (@api_options[:authenticate?] == true) ? true : false
      end
      
      # Access an individual parameter by key (symbol or string)
      #
      def [](key)
        list[key.to_s]
      end
      
      def boundary # :nodoc:
        @boundary ||= Digest::MD5.hexdigest(rand.to_s)
      end
      
      # Generate the query string representation of this parameter 
      # list - e.g. <tt>foo=bar&blee=baz</tt>
      #
      def to_query
        list.values.map(&:to_query).join('&')
      end
      
      # Generate the form representation of this parameter list including the
      # boundary
      #
      def to_form
        form = list.values.map {|p| "--#{self.boundary}\r\n#{p.to_form}" }.join
        form << "--#{self.boundary}--"

        form
      end
      
      def signature # :nodoc:
        parameters_to_sign = @list.values.reject {|p| !p.include_in_signature? }
        signature_text = parameters_to_sign.sort.map {|p| "#{p.name}#{p.value}" }.join

        Digest::MD5.hexdigest("#{Fleakr.shared_secret}#{signature_text}")
      end
      
      private
      def list
        list = @list
        list.merge!('api_sig' => ValueParameter.new('api_sig', signature, false)) if self.sign?
        
        list
      end
    end
  end
end