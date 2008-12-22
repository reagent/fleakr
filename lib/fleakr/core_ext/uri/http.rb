module URI
  class HTTP
    
    alias_method :original_query=, :query=
    def query=(query)
      if query.is_a?(Hash)
        self.original_query = query.map {|key, value| "#{key}=#{CGI.escape(value)}" }.join('&')
      else
        self.original_query = query
      end
    end
    
  end
end