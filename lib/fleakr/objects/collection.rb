module Fleakr
  module Objects # :nodoc:
    
    # = Collection
    #
    # == Attributes
    # 
    # [id] The ID for this collection
    # [title] The title of this collection
    # [description] The description of this collection
    # [small_icon_url] The URL for the small icon that represents this collection
    # [large_icon_url] The URL for the large icon that represents this collection
    # 
    class Collection

      include Fleakr::Support::Object

      flickr_attribute :id, :title, :description
      flickr_attribute :created, :from => '@datecreate'
      flickr_attribute :small_icon_url, :from => '@iconsmall'
      flickr_attribute :large_icon_url, :from => '@iconlarge'

      find_one :by_id, :call => 'collections.getInfo', :path => 'collection'
      find_all :by_user_id, :call => 'collections.getTree', :path => 'collections/collection'

      # When was this collection created?
      #
      def created_at
        Time.at(created.to_i)
      end
      
      # The sets associated with this collection
      #
      def sets
        sibling_nodes_for('set').map {|n| Set.new(n) }
      end
      
      # The collections associated with this collection
      #
      def collections
        sibling_nodes_for('collection').map {|n| Collection.new(n) }
      end
      
      private
      def sibling_nodes_for(node) # :nodoc:
        nodes    = []
        selector = "/collection/#{node}"

        document = Hpricot.XML(self.document.to_s)
        document.search(selector) {|e| nodes << e }
        
        nodes
      end
      
    end
  end
end