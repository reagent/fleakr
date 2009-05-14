require File.dirname(__FILE__) + '/../../../test_helper'

module Fleakr::Api
    
  class OptionTest < Test::Unit::TestCase
    
    def self.should_know_the_class_for(type, options)
      should "know the class for the :#{type} type" do
        Option.class_for(type).should == options[:is]
      end
    end
    
    context "The Option class" do
      should_know_the_class_for :title,       :is => Fleakr::Api::SimpleOption
      should_know_the_class_for :description, :is => Fleakr::Api::SimpleOption
      should_know_the_class_for :tags,        :is => Fleakr::Api::TagOption
      should_know_the_class_for :viewable_by, :is => Fleakr::Api::ViewOption
      should_know_the_class_for :level,       :is => Fleakr::Api::LevelOption
      should_know_the_class_for :type,        :is => Fleakr::Api::TypeOption
      should_know_the_class_for :hide?,       :is => Fleakr::Api::HiddenOption
      
      should "be able to create an option for a type" do
        option = stub()
        
        Option.expects(:class_for).with(:title).returns(Fleakr::Api::SimpleOption)
        Fleakr::Api::SimpleOption.expects(:new).with(:title, 'blip').returns(option)
        
        Option.for(:title, 'blip').should == option
      end
    end
    
  end
  
  class SimpleOptionTest < Test::Unit::TestCase
    
    context "An instance of the SimpleOption class" do
      should "have a type" do
        so = SimpleOption.new(:title, 'blip')
        so.type.should == :title
      end
      
      should "have a value" do
        so = SimpleOption.new(:title, 'blip')
        so.value.should == 'blip'
      end
      
      should "be able to generate a hash representation of itself" do
        so = SimpleOption.new(:title, 'blip')
        so.to_hash.should == {:title => 'blip'}
      end
    end
    
  end

  class TagOptionTest < Test::Unit::TestCase
    
    context "An instance of the TagOption class" do
      
      should "normalize the input value to an array" do
        to = TagOption.new(:tags, 'blip')
        to.value.should == ['blip']
      end
      
      should "be able to generate a hash representation of itself with tags joined on spaces" do
        to = TagOption.new(:tags, %w(bop bip))
        to.to_hash.should == {:tags => '"bop" "bip"'}
      end
      
      should "quote tag values with spaces" do
        to = TagOption.new(:tags, ['tag', 'one with spaces'])
        to.to_hash.should == {:tags => '"tag" "one with spaces"'}
      end
    end
    
  end
  
  class ViewOptionTest < Test::Unit::TestCase
    
    context "An instance of the ViewOption class" do
      should "be able to generate a hash representation for viewing by :everyone" do
        vo = ViewOption.new(:viewable_by, :everyone)
        vo.to_hash.should == {:is_public => 1, :is_family => 0, :is_friend => 0}
      end

      should "be able to generate a hash representation for viewing by :family" do
        vo = ViewOption.new(:viewable_by, :family)
        vo.to_hash.should == {:is_public => 0, :is_family => 1, :is_friend => 0}
      end
      
      should "be able to generate a hash representation for viewing by :friends" do
        vo = ViewOption.new(:viewable_by, :friends)
        vo.to_hash.should == {:is_public => 0, :is_family => 0, :is_friend => 1}
      end
      
      should "know the visibility is public if value is set to :everyone" do
        vo = ViewOption.new(:viewable_by, :everyone)
        vo.public?.should be(true)
      end
      
      should "know the visibility is not public if :everyone is not the only value" do
        vo = ViewOption.new(:viewable_by, [:everyone, :family])
        vo.public?.should be(false)
      end
      
      should "know that its visible to friends and family if specified as such" do
        vo = ViewOption.new(:viewable_by, [:friends, :family])
        vo.friends?.should be(true)
        vo.family?.should be(true)
      end
      
    end
    
  end

  class LevelOptionTest < Test::Unit::TestCase
    
    context "An instance of the LevelOption class" do
      
      should "be able to generate a hash representation for the :safe level" do
        lo = LevelOption.new(:level, :safe)
        lo.to_hash.should == {:safety_level => 1}
      end
      
      should "be able to generate a hash representation for the :moderate level" do
        lo = LevelOption.new(:level, :moderate)
        lo.to_hash.should == {:safety_level => 2}
      end
      
      should "be able to generate a hash representation for the :restricted level" do
        lo = LevelOption.new(:level, :restricted)
        lo.to_hash.should == {:safety_level => 3}
      end
      
    end
    
  end

  class TypeOptionTest < Test::Unit::TestCase
    
    context "An instance of the TypeOption class" do
      
      should "be able to generate a hash representation for the :photo type" do
        to = TypeOption.new(:type, :photo)
        to.to_hash.should == {:content_type => 1}
      end
      
      should "be able to generate a hash representation for the :screenshot type" do
        to = TypeOption.new(:type, :screenshot)
        to.to_hash.should == {:content_type => 2}
      end
      
      should "be able to generate a hash representation for the :other type" do
        to = TypeOption.new(:type, :other)
        to.to_hash.should == {:content_type => 3}
      end
      
    end
    
  end
  
  class HiddenOptionTest < Test::Unit::TestCase
    
    context "An instance of the HiddenOption class" do
      
      should "be able to generate a hash representation when set to true" do
        ho = HiddenOption.new(:hide?, true)
        ho.to_hash.should == {:hidden => 2}
      end
      
      should "be able to generate a hash representation when set to false" do
        ho = HiddenOption.new(:hide?, false)
        ho.to_hash.should == {:hidden => 1}
      end
      
    end
    
  end

end