require File.expand_path('../../../../test_helper', __FILE__)

module Fleakr::Objects
  class MetadataCollectionTest < Test::Unit::TestCase

    context "An instance of the MetadataCollection class" do

      should "have a photo" do
        photo = stub()
        collection = MetadataCollection.new(photo)

        collection.photo.should == photo
      end

      context "with a photo" do
        setup do
          @photo      = stub(:id => '1')
          @collection = MetadataCollection.new(@photo)
        end

        should "be able to fetch the metadata" do
          element = stub(:label => 'Label')
          Metadata.stubs(:find_all_by_photo_id).with(@photo.id, {}).returns([element])

          @collection.data.should == {'Label' => element}
        end

        should "be able to pass authentication informatin through when finding metadata" do
          collection = MetadataCollection.new(@photo, :auth_token => 'toke')
          element = stub(:label => 'Label')

          Metadata.stubs(:find_all_by_photo_id).with(@photo.id, :auth_token => 'toke').returns([element])

          collection.data.should == {'Label' => element}
        end

        should "know the keys for the metadata" do
          @collection.stubs(:data).with().returns({'One' => nil, 'Two' => nil})
          @collection.keys.sort.should == ['One', 'Two']
        end

        should "be able to access an individual value by key" do
          @collection.stubs(:data).with().returns({'FileSize' => stub(:raw => '3.2 MB')})
          @collection['FileSize'].should == '3.2 MB'
        end

        should "be able to iterate over items in the collection" do
          element_1 = stub()
          element_2 = stub()

          data     = {'One' => element_1, 'Two' => element_2}
          iterated = {}

          @collection.stubs(:data).with().returns(data)
          @collection.each {|key, value| iterated[key] = value }

          iterated.should == data
        end

      end

    end
  end
end
