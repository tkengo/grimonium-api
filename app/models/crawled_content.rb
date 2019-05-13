class CrawledContent < ApplicationRecord
  belongs_to :crawled_url, foreign_key: 'url_id', optional: true

  enum scrape_status: {
    unscrape: 0,
    scraping: 1,
    scraped: 2,
    failed: 3
  }

  def scrape!
    begin
      update_attribute(:scrape_status, :scraping)

      class_name, method = scraper.split('.')
      "Grimoire::Scrapers::#{class_name}".constantize.new(self).send(method)

      update!(
        scrape_status: :scraped,
        scraped_at: Time.zone.now
      )
    rescue Exception => e
      logger.fatal(e)
      logger.fatal(e.backtrace.join("\n"))
      update_attribute(:scrape_status, :failed)
    end
  end

  def update_scrape_result(itemkey, content)
    hashkey = itemkey.to_sha1

    result = ScrapeResult.where(content_id: id, hashkey: hashkey).first ||
             ScrapeResult.new(
               content_id: id,
               hashkey: hashkey,
               itemkey: itemkey
             )

    result.content = content.is_a?(Hash) ? content.to_json : content
    result.save
  end

  def url
    crawled_url.url
  end

  def as_html
    @html_content ||= Nokogiri::HTML.parse(content, nil, charset)
  end
end
