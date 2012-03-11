require 'open-uri'
require 'pstore'

class Medium < ActiveRecord::Base
  if ENV["RAILS_ENV"] == 'development'
    has_attached_file :image,
        :storage => :filesystem,
        :styles => { :icon => "100x64#", :medium => "680x600>", :thumb => "206x132#" }
  else
    has_attached_file :image,
        :storage => Rails.env.production? ? :s3 : :filesystem,
        :bucket => 'dans-le-dur',
        :s3_alias_url => 'cdn.dansledur.com',
        :s3_credentials => {
          :access_key_id => ENV['S3_KEY'],
          :secret_access_key => ENV['S3_SECRET']
        },
        :styles => { :icon => "100x64#", :medium => "680x600#", :thumb => "206x132#" }
  end
  acts_as_taggable
  attr_accessor :url

  validates :name, presence: true

  before_create {|m| m.views_count = 0 }

  def url= url
    return unless url.present?
    io = self.class.download(url)
    self.image = io
    io.close
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

  def self.suggestions_for search, limit = 4
    suggestions = Hash.new{|h, k| h[k] = []}
    ActsAsTaggableOn::Tag.all.each do |t|
      suggestions[Text::Levenshtein.distance(search, t.name)] << t.name
    end
    suggestions = Hash[suggestions.sort]
    a = []
    while a.count < limit
      a += suggestions.delete(suggestions.keys.first)
    end
    a[0..limit]
  end

  def next
    Medium.order(:id).where("id > ?", self.id).first
  end

  def previous
    Medium.order(:id).where("id < ?", self.id).last
  end

  def trash?
    tag_list.include? "trash"
  end

  def filtered_thumb_url
    self.trash? ? "thumb-trash.gif" : image.url(:thumb)
  end

  def touch!
    Medium.update_all("views_count = #{self.views_count.to_i + 1}", "id = #{self.id}")
  end

  protected  
  def self.download url
    io = open(url)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue => e # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    p e
    io.close
  end
end
