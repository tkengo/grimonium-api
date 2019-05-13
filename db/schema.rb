# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_09_07_085232) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "crawled_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "url_id"
    t.string "scraper", limit: 128
    t.text "charset", limit: 255
    t.text "content", limit: 4294967295
    t.text "header", limit: 4294967295
    t.integer "scrape_status", limit: 2, default: 0
    t.datetime "scraped_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_id"], name: "index_crawled_contents_on_url_id"
  end

  create_table "crawled_urls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "hashkey", limit: 40
    t.string "url", limit: 1024
    t.integer "crawl_count", default: 0
    t.integer "latest_content_id"
    t.datetime "last_crawled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashkey"], name: "index_crawled_urls_on_hashkey"
  end

  create_table "scrape_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "content_id"
    t.string "itemkey"
    t.string "hashkey", limit: 40
    t.text "content", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_scrape_results_on_content_id"
    t.index ["hashkey"], name: "index_scrape_results_on_hashkey"
  end

  create_table "url_queues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "hashkey", limit: 40
    t.string "url", limit: 1024
    t.string "crawler", limit: 128
    t.string "scraper", limit: 128
    t.text "info", limit: 4294967295
    t.integer "crawl_status", limit: 2, default: 0
    t.integer "priority", default: 0
    t.integer "failed_count", default: 0
    t.datetime "queued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashkey"], name: "index_url_queues_on_hashkey"
  end

end
