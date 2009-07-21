require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Objects
  class ContactTest < Test::Unit::TestCase

    context "The Contact class" do
      
      should "return a list of users for a specified user's contacts" do
        user_1, user_2 = stub(), stub()

        contact_1, contact_2 = [stub(:to_user => user_1), stub(:to_user => user_2)]

        response = mock_request_cycle :for => 'contacts.getPublicList', :with => {:user_id => '1'}

        contact_1_doc, contact_2_doc = (response.body/'rsp/contacts/contact').to_a

        Contact.stubs(:new).with(contact_1_doc).returns(contact_1)
        Contact.stubs(:new).with(contact_2_doc).returns(contact_2)

        Contact.find_all_by_user_id('1').should == [user_1, user_2]
      end
      
      should "return a list of users for an authenticated user" do
        response = mock_request_cycle :for => 'contacts.getList', :with => {}
        contact_1, contact_2 = [stub("contact"), stub('contact')]
        contact_1_doc, contact_2_doc = (response.body/'rsp/contacts/contact').to_a

        Contact.stubs(:new).with(contact_1_doc).returns(@contact_1)
        Contact.stubs(:new).with(contact_2_doc).returns(@contact_2)
        Contact.find_all.should == [@user_1, @user_2]
      end
      
    end

    context "An instance of the Contact class" do
      context "when populating from an XML document with public contacts" do
        setup do
          @object = Contact.new(Hpricot.XML(read_fixture('contacts.getPublicList')).at('contacts/contact'))
        end

        should_have_a_value_for :id          => '9302864@N42'
        should_have_a_value_for :username    => 'blinky'
        should_have_a_value_for :icon_server => '2263'
        should_have_a_value_for :icon_farm   => '3'

      end
      
      context "when populating from an XML document with authenticated user's contacts" do
        setup do
          @object = Contact.new(Hpricot.XML(read_fixture('contacts.getList')).at('contacts/contact'))
        end

        should_have_a_value_for :id           => '9302864@N42'
        should_have_a_value_for :username     => 'blinky'
        should_have_a_value_for :icon_server  => '2263'
        should_have_a_value_for :icon_farm    => '3'
        should_have_a_value_for :name         => 'Mr Blinky'
        should_have_a_value_for :location     => 'Middletown'

      end


      context "in general" do
        
        should "be able to convert to a user" do
          contact = Contact.new
          user    = mock()
          
          User.stubs(:new).returns(user)
          
          [:id, :username, :icon_server, :icon_farm, :name, :location].each do |method|
            contact.stubs(method).with().returns(method.to_s)
            user.expects("#{method}=".to_sym).with(method.to_s)
          end
          
          contact.to_user.should == user
        end
        
      end

    end
    
  end
end