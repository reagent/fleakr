module Fleakr
  module Objects # :nodoc:
    class Contact

      include Fleakr::Support::Object

      flickr_attribute :id, :attribute => 'nsid'
      flickr_attribute :username, :attribute => 'username'
      flickr_attribute :icon_server, :attribute => 'iconserver'
      flickr_attribute :icon_farm, :attribute => 'iconfarm'

      # Retrieve a list of contacts for the specified user ID and return an initialized
      # collection of #User objects
      def self.find_all_by_user_id(user_id)
        response = Fleakr::Api::Request.with_response!('contacts.getPublicList', :user_id => user_id)
        (response.body/'contacts/contact').map {|c| Contact.new(c).to_user }
      end
      
      def to_user # :nodoc:
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