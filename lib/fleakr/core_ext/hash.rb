class Hash

  # Extract the matching keys from the source hash and return
  # a new hash with those keys:
  #
  #   >> h = {:a => 'b', :c => 'd'}
  #   => {:a=>"b", :c=>"d"}
  #   >> h.extract!(:a)
  #   => {:a=>"b"}
  #   >> h
  #   => {:c=>"d"}
  #
  def extract!(*keys)
    value = {}
    
    keys.each {|k| value.merge!({k => self[k]}) if self.has_key?(k) }
    keys.each {|k| delete(k) }
    
    value
  end
  
end