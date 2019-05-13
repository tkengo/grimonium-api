module Grimonium::Crawlers
  class Headless < Base
    attr_reader :session

    UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"

    CAPS = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => {
      binary: Settings.chrome.binary,
      args: [ '--headless', '--disable-gpu', "--user-agent=#{UA}" ]
    })

    def setup
      @session = Selenium::WebDriver.for :chrome, desired_capabilities: CAPS
      @session.manage.timeouts.implicit_wait = 30
    end

    def crawl
      @session.navigate.to record.url

      browse

      html = @session.page_source
      @session.quit

      [ nil, nil, html ]
    end

    def browse
    end
  end
end
