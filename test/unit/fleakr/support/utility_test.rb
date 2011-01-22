require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Support
  class UtilityTest < Test::Unit::TestCase

    context "The Utility class" do

      should "know the module and class name for a given name" do
        Utility.stubs(:class_name).with('foo').returns('Foo')
        Utility.class_name_for('Module', 'foo').should == 'Module::Foo'
      end

      should "know the class name for a singular symbol" do
        Utility.class_name(:photo).should == 'Photo'
      end

      should "know the class name for a pluralized symbol" do
        Utility.class_name(:photos).should == 'Photo'
      end

      should "know the class name for a symbol with underscores" do
        Utility.class_name(:photo_context).should == 'PhotoContext'
      end

      should "know the ID attribute for a simple class name" do
        Utility.id_attribute_for('Foo').should == 'foo_id'
      end

      should "know the ID attribute for a namespaced class name" do
        Utility.id_attribute_for('Namespace::Foo').should == 'foo_id'
      end

      should "know the ID attribute for a camelcased class name" do
        Utility.id_attribute_for('FooBar').should == 'foo_bar_id'
      end

      should "know that nil is blank" do
        Utility.blank?(nil).should be(true)
      end

      should "know that an empty string is blank" do
        Utility.blank?('').should be(true)
      end

      should "know that a string with just spaces is blank" do
        Utility.blank?(' ').should be(true)
      end

      should "return an array and an empty hash when extracting options from an array" do
        array = ['a']
        Utility.extract_options(array).should == [['a'], {}]
      end

      should "return an array and hash parts when extracting options from an array" do
        array = ['a', {:key => 'value'}]
        Utility.extract_options(array).should == [['a'], {:key => 'value'}]
      end

      should "not modify the original array when extracting options from the array" do
        original_array = ['a', {:key => 'value'}]
        array          = original_array.dup

        Utility.extract_options(array)

        array.should == original_array
      end

    end

  end
end