require 'open-uri'

class CrawlingUrl < ApplicationRecord
  enum crawl_status: {
    registered: 0,
    queued: 1,
    crawling: 2,
    failed: 3
  }

  scope :registers, -> { where(crawl_status: :registered) }
  scope :queued, -> { where(crawl_status: :queued) }
  scope :by_url, -> (urls) { where(hashkey: Array(urls).map{|v| v.to_sha1 }) }

  # Register crawling urls to the database.
  def self.register(urls, crawler: :default, scraper: nil, info: nil, priority: 100, force: false)
    crawled_urls = []
    queued_urls  = []

    # Remove urls that are not http or https scheme from the argument urls then next step
    # is normalize which is re-order process of the query parameter.
    urls = Array(urls).inject([]) do |a, url|
      uri = url.to_uri
      if [ 'http', 'https' ].include?(uri.scheme)
        uri.query = uri.query_values.sort.map{|v| v.join('=') }.join('&') if uri.query_values
        a << uri.to_s
      else
        logger.info "#{url} was a invalid url."
      end
      a
    end

    # Remove urls that are already crawled if force crawling is not available.
    unless force
      crawled_urls = CrawledUrl.by_url(urls).each do |url|
        logger.info "#{url.url} was already crawled at #{url.last_crawled_at}."
      end.pluck(:url)
      urls -= crawled_urls
    end

    # Remove urls that are already queued.
    queued_urls = CrawlingUrl.by_url(urls).pluck(:url).each do |url|
      logger.info "#{url} was already queued."
    end

    # Queuing
    rows = (urls - queued_urls).inject([]) do |a, url|
      a << CrawlingUrl.new(
        hashkey: url.to_sha1,
        url: url,
        crawler: (crawler || :default).to_s,
        scraper: scraper,
        info: (info.is_a?(Info) ? info : Info.from(info)).to_json,
        crawl_status: :registered,
        priority: priority,
        failed_count: 0
      )
    end
    CrawlingUrl.import rows

    return OpenStruct.new(
      queued: queued_urls,
      crawled: crawled_urls,
      registered: rows.pluck(:url)
    )
  end

  def self.register_images(urls, path: nil, info: nil, priority: 100, force: false)
    info = Info.from(info)
    info[:path] = path
    self.register(urls, crawler: :image, info: info, priority: priority, force: force)
  end

  def queue!
    return false unless registered?

    update_attributes(
      crawl_status: :queued,
      queued_at: Time.zone.now
    )

    return true
  end

  # Start to crawl. Registered url will be removed from the queue table, then crawled contents
  # will be stored into the database after crawling was successful.
  #
  # == Return:
  # CrawledContent record
  def crawl!(force: false)
    return nil if !force && !queued?
    return nil if crawling?

    old_crawl_status = crawl_status
    update_attribute(:crawl_status, :crawling)

    begin
      crawler_class = Grimonium::Crawler.by crawler
      unless crawler_class
        logger.fatal("Crawler `#{crawler}` was not found.")
        update_attribute(:crawl_status, old_crawl_status)
        return nil
      end

      charset, headers, content = crawler_class.new(self).crawl
    rescue Exception => e
      logger.fatal("Failed crawling #{url}. Here is a stacktrace")
      logger.fatal(e)
      logger.fatal(e.backtrace.join("\n"))
      update_attribute(:crawl_status, :registered)
      return nil
    end

    logger.info "Finished to crawl #{url} ..."
    crawled_content = nil

    begin
      ActiveRecord::Base.transaction do
        crawled_url = CrawledUrl.where(hashkey: hashkey).first ||
                      CrawledUrl.new(
                        hashkey: hashkey,
                        url: url,
                        last_crawled_at: Time.zone.now,
                        crawl_count: 0
                      )
        crawled_url.crawl_count += 1
        crawled_url.save!

        crawled_content = crawled_url.crawled_contents.build(
          scraper: scraper,
          charset: charset,
          content: content,
          header: headers.to_json,
          scrape_status: :unscrape
        )
        crawled_content.save!

        crawled_url.update!(latest_content_id: crawled_content.id)

        destroy!
      end
    rescue Exception => e
      logger.fatal('Failed record update. Here is a stacktrace')
      logger.fatal(e)
      logger.fatal(e.backtrace.join("\n"))

      self.crawl_status = :failed
      self.failed_count += 1
      self.save
    end

    return crawled_content
  end

  def info
    return @info if @info

    @info = read_attribute(:info)
    return nil if @info.nil?
    return ''  if @info.empty?

    begin
      @info = JSON.parse @info, object_class: OpenStruct
      @info = @info.__orig__ if @info.has_key?(:__orig__)
      return @info
    rescue
      return @info
    end
  end

  class Info
    def self.from(info)
      Info.new(info)
    end

    def initialize(info)
      @info = info.is_a?(Hash) ? info : { __orig__: info }
    end

    def to_json
      return nil if @info.has_key?(:__orig__) && @info[:__orig__].nil?
      @json ||= @info.to_json
    end

    def []=(key, value)
      @info[key] = value
      @json = nil
    end

    def [](key)
      @info[key]
    end
  end
end
