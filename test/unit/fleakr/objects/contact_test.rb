require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ContactTest < Test::Unit::TestCase

    describe "The Contact class" do
      
      should "return a list of users for a specified user's contacts" do
        user_1, user_2 = [stub(), stub()]
        contact_1, contact_2 = [stub(:to_user => user_1), stub(:to_user => user_2)]
        
        response = mock_request_cycle :for => 'contacts.getPublicList', :with => {:user_id => '1'}
        
        contact_1_doc, contact_2_doc = (response.body/'rsp/contacts/contact').map
        
        Contact.stubs(:new).with(contact_1_doc).returns(contact_1)
        Contact.stubs(:new).with(contact_2_doc).returns(contact_2)
        
        Contact.find_all_by_user_id('1').should == [user_1, user_2]
      end
      
    end

    describe "An instance of the Contact class" do
      context "when populating from an XML document" do
        before do
          @object = Contact.new(Hpricot.XML(read_fixture('contacts.getPublicList')).at('contacts/contact'))
        end

        should_have_a_value_for :id          => '9302864@N42'
        should_have_a_value_for :username    => 'blinky'
        should_have_a_value_for :icon_server => '2263'
        should_have_a_value_for :icon_farm   => '3'

      end

      context "in general" do
        
        should "be able to convert to a user" do
          contact = Contact.new
          user    = mock()
          
          User.stubs(:new).returns(user)
          
          [:id, :username, :icon_server, :icon_farm].each do |method|
            contact.stubs(method).with().returns(method.to_s)
            user.expects("#{method}=".to_sym).with(method.to_s)
          end
          
          contact.to_user.should == user
        end
        
      end

    end
    
  end
end