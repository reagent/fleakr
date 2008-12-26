module Fleakr
  module Api
    class ParameterList
      
      def initialize(secret, options = {})
        @secret = secret
        @options = options
        
        @list = Hash.new

        self << Parameter.new('auth_token', Request.token.value) if authenticate?
      end
      
      def <<(parameter)
        @list.merge!(parameter.name => parameter)
      end
      
      def sign?
        (@options[:sign?] == true || authenticate?) ? true : false
      end
      
      def authenticate?
        (@options[:authenticate?] == true) ? true : false
      end
      
      def [](key)
        list[key.to_s]
      end
      
      def boundary
        @boundary ||= ('-' * 32) + Digest::MD5.hexdigest(rand.to_s)
      end
      
      def to_query
        list.values.map(&:to_query).join('&')
      end
      
      def to_form
        form = list.map {|k,p| "#{self.boundary}\r\n#{p.to_form}" }.join
        form << "#{self.boundary}--\r\n"

        form
      end
      
      def signature
        parameters_to_sign = @list.reject {|k,p| !p.include_in_signature? }
        signature_text = parameters_to_sign.sort.map {|e| "#{e[1].name}#{e[1].value}" }.join

        Digest::MD5.hexdigest("#{@secret}#{signature_text}")
      end
      
      private
      def list
        list = @list
        list.merge!('api_sig' => Parameter.new('api_sig', signature, false)) if self.sign?
        
        list
      end
    end
  end
end