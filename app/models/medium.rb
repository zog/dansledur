require 'open-uri'
require 'pstore'

class Medium < ActiveRecord::Base
  has_attached_file :image, 
      :storage => :s3,
      :bucket => 'dans-le-dur',
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
      },
      :styles => { :medium => "600x600>", :thumb => "268x150#" }
  acts_as_taggable
  attr_accessor :url
  
  validates :name, presence: true
  
  def url= url
    self.image = self.class.download(url) if url.present?
  end
  
  def self.fetch_from_twitter
      last_id = Setting[:last_mention_id].try :to_i
      if last_id
        mentions = Twitter.mentions since_id: last_id
      else
        last_id = 0
        mentions = Twitter.mentions
      end
      mentions.each do |m|
        begin
          if m.id > last_id
            last_id = m.id
            Setting[:last_mention_id] = m.id
          end
          tags = m.text.scan(/#(\w+)/).flatten
          name = m.text
          urls = m.text.scan(/((https?:\/\/)?[\w\.\-]+\.\w{2,5}(\/[\w.\-\_]+)*)/).map(&:first)
          p m.text
          p urls
          urls.each do |url|
            name = name.gsub(url, "")
          end
          name = name.gsub(/#\w+/, '').gsub(/\@\w+/, "").gsub(/^\s+/, '').gsub(/\s+$/, '').gsub(/\s+/, " ")
          urls.each do |url|
            url = "http://#{url}" unless /https?:\/\//.match(url)
            medium = self.create! url: url, tag_list: tags, name: name
          end
        rescue
      end
    end.count
  end
  
  def next
    Medium.where("id > ?", self.id).first
  end  
  
  def previous
    Medium.where("id < ?", self.id).last
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
