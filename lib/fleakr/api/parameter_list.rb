module Fleakr
  module Api # :nodoc:
    
    # = ParameterList
    #
    # Represents a list of parameters that get passed as part of a
    # MethodRequest or UploadRequest.  These can be transformed as necessary
    # into query strings (using #to_query) or form data (using #to_form)
    #
    class ParameterList
      
      attr_reader :upload_options # :nodoc:
      
      # Create a new parameter list with optional parameters:
      #
      #   list = Fleakr::Api::ParameterList.new(:username => 'reagent')
      # 
      # You can also disable the sending of the authentication token using
      # the second parameter:
      #
      #   list = Fleakr::Api::ParameterList.new({}, false)
      #
      def initialize(options = {}, send_authentication_token = true)
        @send_authentication_token = send_authentication_token
        @options                   = options
        @upload_options            = {}
      end

      # Should we send an authentication token as part of this list of parameters?
      # By default this is true if the token is available as a global value or if 
      # the :auth_token key/value is part of the initial list.  You can override this
      # in the constructor.
      # 
      def send_authentication_token?
        @send_authentication_token && !authentication_token.nil?
      end
      
      # The default options to send as part of the parameter list, defaults to
      # sending the API key
      #
      def default_options
        {:api_key => Fleakr.api_key}
      end
      
      # Should this parameter list be signed? This will be true if Fleakr.shared_secret
      # is set, false if not.
      #
      def sign?
        !Fleakr.shared_secret.blank?
      end
      
      # Generate the query string representation of this parameter 
      # list - e.g. <tt>foo=bar&blee=baz</tt>
      #
      def to_query
        list.map {|element| element.to_query }.join('&')
      end
      
      # Generate the form representation of this parameter list including the
      # boundary
      #
      def to_form
        form = list.map {|p| "--#{boundary}\r\n#{p.to_form}" }.join
        form << "--#{boundary}--"

        form
      end
      
      # Retrieve the authentication token from either the list of parameters
      # or the global value (e.g. Fleakr.auth_token)
      #
      def authentication_token
        Fleakr.auth_token.nil? ? @options[:auth_token] : Fleakr.auth_token
      end
      
      # Add an option to the list that should be sent with a request.
      #
      def add_option(name, value)
        @options.merge!(name => value)
      end
      
      # Add an option that should be sent with an upload request.
      #
      def add_upload_option(name, value)
        @upload_options.merge!(name => value)
      end
      
      def options # :nodoc:
        options = default_options.merge(@options)
        options.merge!(:auth_token => authentication_token) if send_authentication_token?
        
        options
      end
      
      def boundary # :nodoc:
        @boundary ||= Digest::MD5.hexdigest(rand.to_s)
      end
      
      def signature # :nodoc:
        sorted_options = options_without_signature.sort {|a,b| a[0].to_s <=> b[0].to_s }
        signature_text = sorted_options.map {|o| "#{o[0]}#{o[1]}" }.join

        Digest::MD5.hexdigest("#{Fleakr.shared_secret}#{signature_text}")
      end
      
      def options_without_signature # :nodoc:
        options.reject {|k,v| k.to_s == 'api_sig'}
      end
      
      def options_with_signature # :nodoc:
        options_without_signature.merge(:api_sig => signature)
      end
      
      def list # :nodoc:
        options_for_list = sign? ? options_with_signature : options_without_signature 
        value_parameters = options_for_list.map {|k,v| ValueParameter.new(k, v) }
        file_parameters  = upload_options.map {|k,v| FileParameter.new(k, v) }

        value_parameters + file_parameters
      end

    end
  end
end