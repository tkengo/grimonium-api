class Initialize < ActiveRecord::Migration[5.2]
  def change
    create_table :target_urls do |t|
      t.string   :hashkey,      limit: 40
      t.string   :url,          limit: 1024
      t.string   :crawler,      limit: 128
      t.string   :scraper,      limit: 128
      t.text     :info,         limit: 2 ** 32 - 1
      t.integer  :crawl_status, limit: 2, default: 0
      t.integer  :priority,               default: 0
      t.integer  :failed_count,           default: 0
      t.datetime :queued_at
      t.timestamps

      t.index :hashkey
    end

    create_table :crawled_urls do |t|
      t.string   :hashkey,     limit: 40
      t.string   :url,         limit: 1024
      t.integer  :crawl_count, default: 0
      t.integer  :latest_content_id
      t.datetime :last_crawled_at
      t.timestamps

      t.index :hashkey
    end

    create_table :crawled_contents do |t|
      t.integer  :url_id
      t.string   :scraper,       limit: 128
      t.text     :charset,       limit: 10
      t.text     :content,       limit: 2 ** 32 - 1
      t.text     :header,        limit: 2 ** 32 - 1
      t.integer  :scrape_status, limit: 2, default: 0
      t.datetime :scraped_at
      t.timestamps

      t.index :url_id
    end

    create_table :scrape_results do |t|
      t.integer  :content_id
      t.string   :itemkey
      t.string   :hashkey, limit: 40
      t.text     :content, limit: 2 ** 32 - 1
      t.timestamps

      t.index :content_id
      t.index :hashkey
    end
  end
end
