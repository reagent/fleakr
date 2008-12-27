module Fleakr
  module Api
    class ParameterList
      
      def initialize(secret, options = {})
        @secret = secret
        @api_options = options.extract!(:sign?, :authenticate?)
        
        @list = Hash.new

        options.each {|k,v| self << ValueParameter.new(k.to_s, v) }

        self << ValueParameter.new('api_key', Fleakr.api_key)
        self << ValueParameter.new('auth_token', Request.token.value) if authenticate?
      end
      
      def <<(parameter)
        @list.merge!(parameter.name => parameter)
      end
      
      def sign?
        (@api_options[:sign?] == true || authenticate?) ? true : false
      end
      
      def authenticate?
        (@api_options[:authenticate?] == true) ? true : false
      end
      
      def [](key)
        list[key.to_s]
      end
      
      def boundary
        @boundary ||= Digest::MD5.hexdigest(rand.to_s)
      end
      
      def to_query
        list.values.map(&:to_query).join('&')
      end
      
      def to_form
        form = list.values.map {|p| "--#{self.boundary}\r\n#{p.to_form}" }.join
        form << "--#{self.boundary}--"

        form
      end
      
      def signature
        parameters_to_sign = @list.values.reject {|p| !p.include_in_signature? }
        signature_text = parameters_to_sign.sort.map {|p| "#{p.name}#{p.value}" }.join

        Digest::MD5.hexdigest("#{@secret}#{signature_text}")
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