require 'open-uri'

class Medium < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  acts_as_taggable
  attr_accessor :url
  
  def url= url
    self.image = self.class.download(url) if url.present?
    p self.image
  end
  
  protected  
  def self.download url
    io = open(url)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue => e # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    p e
  end
end
