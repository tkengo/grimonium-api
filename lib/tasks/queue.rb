class Tasks::Queue < Tasks::Base
  def usage
    puts <<-EOD
Usage:
  gr crawl [OPTIONS] [URLS]

The `queue` command registers urls you want to crawl. Urls which already are crawled are never
registered again without -f option.

Example:
  gr crawl http://www.google.com/ http://www.yahoo.com/

Options:
  -f, --force    Register again even if urls have been already crawled.
  -c, --crawler  Specify the crawler.
  -s, --scraper  Specify the scraper.

  -h, --help     Show help.
    EOD
  end

  def process(opts)
    usage or return if opts.arguments.empty?

    CrawlingUrl.register(
      opts.arguments,
      crawler: opts[:crawler],
      scraper: opts[:scraper],
      force: opts.force?
    )
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
