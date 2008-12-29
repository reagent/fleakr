module Fleakr
  module Objects # :nodoc:
    class Contact # :nodoc:

      include Fleakr::Support::Object

      flickr_attribute :id, :from => '@nsid'
      flickr_attribute :username
      flickr_attribute :icon_server, :from => '@iconserver'
      flickr_attribute :icon_farm,   :from => '@iconfarm'

      # Retrieve a list of contacts for the specified user ID and return an initialized
      # collection of #User objects
      def self.find_all_by_user_id(user_id)
        response = Fleakr::Api::MethodRequest.with_response!('contacts.getPublicList', :user_id => user_id)
        (response.body/'contacts/contact').map {|c| Contact.new(c).to_user }
      end
      
      def to_user
        user = User.new
        self.class.attributes.each do |attribute|
          attribute_name = attribute.name
          user.send("#{attribute.name}=".to_sym, self.send(attribute.name))
        end

        user
      end

    end
  end
end