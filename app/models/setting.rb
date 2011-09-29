class Setting < ActiveRecord::Base
  def self.[] key
    self.find_by_key(key).try :value
  end
  
  def self.[]= key, value
    self.find_or_create_by_key(key).update_attribute :value, value.to_s
  rescue => e
    p e
    raise
  end
end
