class Tasks::Crawl < Tasks::Base
  def usage
    puts <<-EOD
Usage:
  gr crawl [OPTIONS] [URLS]

The `crawl` command can start to crawl contents of the specified urls. Crawled contents will be
stored into a database.
Urls which already are crawled are never crawled again without -f option.

Example:
  gr crawl http://www.google.com/ http://www.yahoo.com/

Options:
  -f, --force    Do crawling again even if urls have been already crawled.
  -c, --crawler  Specify the crawler.
  -s, --scraper  Specify the scraper.

  -h, --help     Show help.
    EOD
  end

  def process(opts)
    usage or return if opts.arguments.empty?

    urls, ids = [], []
    opts.arguments.each do |url|
      if url =~ /^\d+$/
        ids << url
      else
        urls << url
      end
    end

    urls = CrawlingUrl.register(
      urls,
      crawler: opts[:crawler],
      scraper: opts[:scraper],
      force: opts.force?
    )
    contents = CrawlingUrl.by_url(urls.registered + urls.queued) + CrawlingUrl.where(id: ids)
    contents.map!(&:crawl!)

    if opts[:scraper].present?
      contents.select(&:present?).map(&:scrape!)
    end
  end

  def parse_opts(argv)
    Slop.parse argv do |o|
      o.bool   '-f', '--force'
      o.string '-c', '--crawler', default: nil
      o.string '-s', '--scraper', default: nil

      o.on '-h', '--help', 'print the version' do
        usage
        exit
      end
    end
  end
end
