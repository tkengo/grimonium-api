class Tasks::Scrape < Tasks::Base
  def usage
    puts <<-EOD
Usage:
  gr scrape [OPTIONS] [IDS]

The `scrape` command can start to scrape contents of the specified id. Scraped contents will be
stored into a database.

Example:
  gr scrape 1 2 3

Options:
  -h, --help  Show help.
    EOD
  end

  def process(opts)
    ids = opts.arguments
    usage or return if ids.empty?

    CrawledContent.find(ids).map(&:scrape!)
  end

  def parse_opts(argv)
    Slop.parse argv do |o|
      o.on '-h', '--help', 'print the version' do
        usage
        exit
      end
    end
  end
end
