module Fleakr
  module Api
    
    class FileParameter < Parameter
      
      MIME_TYPES = {
        '.jpg' => 'image/jpeg',
        '.png' => 'image/png',
        '.gif' => 'image/gif'
      }
      
      def initialize(name, filename)
        @filename = filename
        super(name, false)
      end
      
      def mime_type
        MIME_TYPES[File.extname(@filename)]
      end
      
      def value
        @value ||= File.read(@filename)
      end
      
      def to_form
        "Content-Disposition: form-data; name=\"#{self.name}\"; filename=\"#{@filename}\"\r\n" +
        "Content-Type: #{self.mime_type}\r\n" +
        "\r\n" +
        "#{self.value}\r\n"
      end
      
    end
    
  end
end