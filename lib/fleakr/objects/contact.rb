module Fleakr
  module Objects
    class Contact

      include Fleakr::Support::Object

      flickr_attribute :id, :attribute => 'nsid'
      flickr_attribute :username, :attribute => 'username'
      flickr_attribute :icon_server, :attribute => 'iconserver'
      flickr_attribute :icon_farm, :attribute => 'iconfarm'

      def self.find_all_by_user_id(user_id)
        response = Fleakr::Api::Request.with_response!('contacts.getPublicList', :user_id => user_id)
        (response.body/'contacts/contact').map {|c| Contact.new(c).to_user }
      end
      # 
      # find_all :by_user_id, :call => 'contacts.getPublicList', :path => 'contacts/contact', :class_name => 'User'

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