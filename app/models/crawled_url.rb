class CrawledUrl < ApplicationRecord
  has_many :crawled_contents, foreign_key: 'url_id'

  scope :by_url, -> (urls) { where(hashkey: Array(urls).map{|v| v.to_sha1 }) }
end
