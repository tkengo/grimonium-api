class Api::Queues::CrawlsController < Api::ApplicationController
  def create
    url = CrawlingUrl.find params[:url_id]
    @content = url.crawl!
  end
end
