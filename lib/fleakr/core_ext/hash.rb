class Hash
  
  def extract!(*keys)
    value = {}
    
    keys.each {|k| value.merge!({k => self[k]}) if self.has_key?(k) }
    keys.each {|k| delete(k) }
    
    value
  end
  
end